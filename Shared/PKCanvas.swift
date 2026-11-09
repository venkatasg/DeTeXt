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
    
    @MainActor
    class Coordinator: NSObject, PKCanvasViewDelegate {
        var pkCanvas: PKCanvas
        var labelScores: LabelScores

        // Starts loading the model in the background as soon as the canvas is created;
        // predictions await this, so a stroke drawn before loading finishes just waits
        private let model = Task {
            let config = MLModelConfiguration()
            config.computeUnits = .all
            return try await deTeX.load(configuration: config)
        }

        // The prediction for the most recent drawing, kept so it can be cancelled when superseded
        private var predictionTask: Task<Void, Never>?

        private let trainedImageSize = CGSize(width: 300, height: 200)
        
        init(_ pkCanvas: PKCanvas, labelScores: LabelScores) {
            self.pkCanvas = pkCanvas
            self.labelScores  = labelScores
        }

        func canvasViewDrawingDidChange(_ canvasView: PKCanvasView) {
            // Only the latest drawing matters, so drop any prediction still running for an earlier one
            predictionTask?.cancel()

            // An empty canvas (cleared or fully erased) has nothing to predict
            guard !canvasView.drawing.bounds.isEmpty else { return }

            // haptic feedback
            modelHaptics()

            let processedDrawing = canvasView.drawing.normalizedForModel(canvasSize: canvasView.frame.size)

            predictionTask = Task {
                await predict(drawing: processedDrawing)
            }
        }

        // find the most likely class labels corresponding to the drawing
        private func predict(drawing: PKDrawing) async {
            do {
                let model = try await model.value
                guard let pixelBuffer = await drawing.modelInput(size: trainedImageSize), !Task.isCancelled else { return }

                // Runs off the main thread, so the UI stays responsive while the model works
                let result = try await model.prediction(input: deTeXInput(drawing: pixelBuffer))

                // A newer stroke or a clear may have superseded this drawing while the model ran
                guard !Task.isCancelled else { return }
                labelScores.updateScores(updatedScores: result.classLabelProbs)
            }
            catch {
                print("Prediction error: \(error)")
            }
        }
    }

    
    
}
