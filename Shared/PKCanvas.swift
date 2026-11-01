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
    var labelScores: LabelScores

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
    
    class Coordinator: NSObject, PKCanvasViewDelegate {
        var pkCanvas: PKCanvas
        var labelScores: LabelScores
        
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
            
            let processedDrawing = canvasView.drawing.normalizedForModel(canvasSize: canvasView.frame.size)
            
            // Use Task to handle async work
            Task { @MainActor in
                await predict(drawing: processedDrawing)
            }
        }
        
        // find the most likely class labels corresponding to the drawing
        private func predict(drawing: PKDrawing) async {
            guard let pixelBuffer = await drawing.modelInput(size: trainedImageSize) else { return }
            do {
                let result = try model.prediction(drawing: pixelBuffer)
                labelScores.updateScores(updatedScores: result.classLabelProbs)
            }
            catch {
                print("Prediction error\n")
            }
                
        }
    }

    
    
}
