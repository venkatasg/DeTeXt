//
//  ImageHelpersTests.swift
//  DeTeXtTests
//
//  The model only works if drawings are rendered exactly as during training: white strokes
//  on black, centred, in a 300×200 BGRA buffer.
//

import Testing
import PencilKit
import CoreML
@testable import DeTeXt

@Suite("Drawing preprocessing")
struct ImageHelpersTests {
    let cross = SyntheticDrawing.make([[(0.2, 0.2), (0.8, 0.8)], [(0.8, 0.2), (0.2, 0.8)]])

    @Test("Model input size matches what the app renders")
    func modelExpectsTrainedImageSize() throws {
        let input = try #require(Recognizer.shared.model.model.modelDescription.inputDescriptionsByName["drawing"])
        let constraint = try #require(input.imageConstraint)
        #expect(constraint.pixelsWide == Int(Recognizer.inputSize.width))
        #expect(constraint.pixelsHigh == Int(Recognizer.inputSize.height))
    }

    @Test("Normalising keeps every stroke and point")
    func normalisingPreservesGeometry() {
        let normalized = cross.normalizedForModel(canvasSize: SyntheticDrawing.canvasSize)
        #expect(normalized.strokes.count == cross.strokes.count)
        for (original, processed) in zip(cross.strokes, normalized.strokes) {
            #expect(processed.path.count == original.path.count)
            #expect(processed.path.first?.location == original.path.first?.location)
            #expect(processed.path.last?.location == original.path.last?.location)
        }
    }

    @Test("Normalising uses white ink and a uniform pen size")
    func normalisingInkAndSize() throws {
        let normalized = cross.normalizedForModel(canvasSize: SyntheticDrawing.canvasSize)
        let sizes = Set(normalized.strokes.flatMap { $0.path.map(\.size.width) })
        #expect(sizes.count == 1)
        for stroke in normalized.strokes {
            #expect(stroke.ink.inkType == .pen)
            var white: CGFloat = 0
            stroke.ink.color.getWhite(&white, alpha: nil)
            #expect(white > 0.99)
        }
    }

    @Test("Pen size grows with how much of the canvas the drawing fills")
    func penSizeScalesWithDrawing() throws {
        let small = SyntheticDrawing.make([[(0, 0), (1, 1)]], size: 50).normalizedForModel(canvasSize: SyntheticDrawing.canvasSize)
        let large = SyntheticDrawing.make([[(0, 0), (1, 1)]], size: 250).normalizedForModel(canvasSize: SyntheticDrawing.canvasSize)
        let smallSize = try #require(small.strokes.first?.path.first?.size.width)
        let largeSize = try #require(large.strokes.first?.path.first?.size.width)
        #expect(smallSize > 2.5)
        #expect(largeSize > smallSize)
    }

    @Test("Model input is a 300×200 BGRA pixel buffer")
    func modelInputFormat() async throws {
        let buffer = try #require(await cross.normalizedForModel(canvasSize: SyntheticDrawing.canvasSize).modelInput(size: Recognizer.inputSize))
        #expect(CVPixelBufferGetWidth(buffer) == 300)
        #expect(CVPixelBufferGetHeight(buffer) == 200)
        #expect(CVPixelBufferGetPixelFormatType(buffer) == kCVPixelFormatType_32BGRA)
    }

    @Test("Strokes render white on a black background, centred in the frame")
    func modelInputContents() async throws {
        let buffer = try #require(await cross.normalizedForModel(canvasSize: SyntheticDrawing.canvasSize).modelInput(size: Recognizer.inputSize))
        let pixels = PixelReader(buffer)

        // Corners are background
        #expect(pixels.brightness(x: 0, y: 0) == 0)
        #expect(pixels.brightness(x: 299, y: 199) == 0)
        // The centre of the X is ink
        #expect(pixels.brightness(x: 150, y: 100) > 200)

        // Ink is centred: its bounding box is roughly symmetric about the middle
        let ink = pixels.inkBounds()
        #expect(abs(ink.midX - 150) < 5)
        #expect(abs(ink.midY - 100) < 5)
        // and 20% padding is left around the longer side
        #expect(ink.height < 200 * 0.9)
    }
}

/// Reads brightness values from a locked BGRA pixel buffer
private struct PixelReader {
    let width: Int, height: Int
    private let bytes: [UInt8]
    private let bytesPerRow: Int

    init(_ buffer: CVPixelBuffer) {
        CVPixelBufferLockBaseAddress(buffer, .readOnly)
        defer { CVPixelBufferUnlockBaseAddress(buffer, .readOnly) }
        width = CVPixelBufferGetWidth(buffer)
        height = CVPixelBufferGetHeight(buffer)
        bytesPerRow = CVPixelBufferGetBytesPerRow(buffer)
        let base = CVPixelBufferGetBaseAddress(buffer)!.assumingMemoryBound(to: UInt8.self)
        bytes = Array(UnsafeBufferPointer(start: base, count: bytesPerRow * height))
    }

    /// Mean of the B, G and R channels
    func brightness(x: Int, y: Int) -> Int {
        let offset = y * bytesPerRow + x * 4
        return (Int(bytes[offset]) + Int(bytes[offset + 1]) + Int(bytes[offset + 2])) / 3
    }

    /// Bounding box of every pixel brighter than mid-grey
    func inkBounds() -> CGRect {
        var (minX, minY, maxX, maxY) = (width, height, 0, 0)
        for y in 0..<height {
            for x in 0..<width where brightness(x: x, y: y) > 128 {
                (minX, minY, maxX, maxY) = (min(minX, x), min(minY, y), max(maxX, x), max(maxY, y))
            }
        }
        return CGRect(x: minX, y: minY, width: maxX - minX, height: maxY - minY)
    }
}
