// Helpers for turning a drawing into the Core ML model's input

import UIKit
import PencilKit

extension PKDrawing {
    private static let mlProcessingInk = PKInk(.pen, color: .white)

    // Redraws every stroke with white ink and a uniform point size scaled to how much of the
    // canvas the drawing covers, so thin and thick strokes look alike to the model
    func normalizedForModel(canvasSize: CGSize) -> PKDrawing {
        // Find the scaling factor for drawings and appropriate pointsize
        let scaleH = bounds.size.width / canvasSize.width
        let scaleW = bounds.size.height / canvasSize.height
        let scale = max(scaleH, scaleW)
        let pointSize = CGSize(width: 2.5 + scale*5.5, height: 2.5+scale*5.5)

        return PKDrawing(strokes: strokes.map { stroke in
            PKStroke(
                ink: Self.mlProcessingInk,
                path: PKStrokePath(
                    controlPoints: stroke.path.map { point in
                        PKStrokePoint(
                            location: point.location,
                            timeOffset: point.timeOffset,
                            size: pointSize,
                            opacity: 2,
                            force: point.force,
                            azimuth: .zero,
                            altitude: .pi/2
                        )
                    },
                    creationDate: Date()
                )
            )
        })
    }

    // Renders the drawing the way the model was trained: white strokes on black, centred in a
    // frame with the model's aspect ratio and 20% padding, drawn straight into the input buffer
    func modelInput(size: CGSize) async -> CVPixelBuffer? {
        let attributes = [kCVPixelBufferCGImageCompatibilityKey: true,
                          kCVPixelBufferCGBitmapContextCompatibilityKey: true] as CFDictionary
        var buffer: CVPixelBuffer?
        guard CVPixelBufferCreate(kCFAllocatorDefault, Int(size.width), Int(size.height), kCVPixelFormatType_32BGRA, attributes, &buffer) == kCVReturnSuccess,
              let pixelBuffer = buffer else { return nil }

        CVPixelBufferLockBaseAddress(pixelBuffer, [])
        defer { CVPixelBufferUnlockBaseAddress(pixelBuffer, []) }

        let bitmapInfo = CGBitmapInfo.byteOrder32Little.rawValue | CGImageAlphaInfo.premultipliedFirst.rawValue
        guard let context = CGContext(data: CVPixelBufferGetBaseAddress(pixelBuffer), width: Int(size.width), height: Int(size.height), bitsPerComponent: 8, bytesPerRow: CVPixelBufferGetBytesPerRow(pixelBuffer), space: CGColorSpaceCreateDeviceRGB(), bitmapInfo: bitmapInfo) else { return nil }

        context.setFillColor(CGColor(gray: 0, alpha: 1))
        context.fill(CGRect(origin: .zero, size: size))

        // Fit the stroke bounds inside a padded frame with the same aspect ratio as the model input
        let aspectRatio = size.width / size.height
        let frameWidth = max(bounds.width, bounds.height * aspectRatio) * 1.2
        let frameHeight = frameWidth / aspectRatio
        let sourceRect = CGRect(x: bounds.midX - frameWidth / 2, y: bounds.midY - frameHeight / 2, width: frameWidth, height: frameHeight)

        // Always render in light mode so white ink stays white
        await draw(in: context, frame: CGRect(origin: .zero, size: size), from: sourceRect, darkUserInterfaceStyle: false)
        return pixelBuffer
    }
}
