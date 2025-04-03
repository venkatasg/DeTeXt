//
//  PKCanvas.swift
//  iOS
//
//  Created by Venkat on 14/9/20.
//

import SwiftUI
import PencilKit
import CoreML

struct PKCanvas: UIViewRepresentable {
    class Coordinator: NSObject, PKCanvasViewDelegate {
        var pkCanvas: PKCanvas
        @ObservedObject var labelScores: LabelScores
        
        private let mlProcessingInk = PKInk(.pen, color: .white)

        let model: deTeX = {
            do {
                let config = MLModelConfiguration()
                config.computeUnits = .all
                return try deTeX(configuration: config)
            }
            catch {
                print(error)
                fatalError("Couldn't create model")
            }
        }()
        
        private let trainedImageSize = CGSize(width: 300, height: 200)
        
        init(_ pkCanvas: PKCanvas, labelScores: LabelScores) {
            self.pkCanvas = pkCanvas
            self.labelScores  = labelScores
        }

        func canvasViewDrawingDidChange(_ canvasView: PKCanvasView) {
            // if canvasView is empty escape gracefully
            guard !canvasView.drawing.bounds.isEmpty else { return }
            
            // haptic feedback
            modelHaptics()
            
            let processedImage = processDrawing(canvasView)
            
            // Use Task to handle async work
            Task { @MainActor in
                await predictImage(image: processedImage)
            }
        }
        
        private func processDrawing(_ canvasView: PKCanvasView) -> UIImage {
            // Find the scaling factor for drawings and appropriate pointsize
            let scaleH = canvasView.drawing.bounds.size.width / canvasView.frame.width
            let scaleW = canvasView.drawing.bounds.size.height / canvasView.frame.height
            let scale = max(scaleH, scaleW)
            let pointSize = CGSize(width: 2.5 + scale*5.5, height: 2.5+scale*5.5)
            
            // Create new drawing using map to avoid explicit array allocation
            let processedDrawing = PKDrawing(strokes: canvasView.drawing.strokes.map { stroke in
                PKStroke(
                    ink: self.mlProcessingInk,
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
            var image = processedDrawing.image(from: processedDrawing.bounds, scale: 5.0)
            //flip color from black to white in dark mode
            if image.averageColor?.cgColor.components![0] == 0 {
                image = invertColors(image: image)
            }
            // overlay image on a black background
            let processedImage = overlayBlackBg(image: image)
            return processedImage
        }
        
        // find the most likely class labels corresponding to the drawing
        private func predictImage(image: UIImage) async {
            guard let resizedImage = image.resize(newSize: trainedImageSize), let pixelBuffer = resizedImage.toCVPixelBuffer() else { return }
            do {
                let result = try model.prediction(drawing: pixelBuffer)
                labelScores.updateScores(updatedScores: result.classLabelProbs)
            }
            catch {
                print("Prediction error\n")
            }
                
        }
    }

    @ObservedObject var labelScores: LabelScores

    func makeCoordinator() -> Coordinator {
        Coordinator(self, labelScores: labelScores)
    }

    func makeUIView(context: Context) -> PKCanvasView {
        let canvasView = PKCanvasView()
        canvasView.tool = PKInkingTool(.pen, width: 15)
        canvasView.isOpaque = true
        canvasView.isScrollEnabled = false
        canvasView.becomeFirstResponder()
        canvasView.delegate = context.coordinator
        canvasView.drawingPolicy = .anyInput
        
        return canvasView
    }

    func updateUIView(_ canvasView: PKCanvasView, context: Context) {
        if self.labelScores.scores.isEmpty {
            canvasView.drawing = PKDrawing()
        }
    }
    
}
