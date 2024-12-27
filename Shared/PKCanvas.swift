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

        let model: deTeX = {
            do {
                let config = MLModelConfiguration()
                config.computeUnits = .cpuAndNeuralEngine
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
        
//        #if os(iOS)
//        func pencilInteractionDidTap(_ interaction: UIPencilInteraction) {
//            // Clear the drawing when double tapped on pencil
//            self.labelScores.ClearScores()
//        }
//        #endif

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
            let scale = scaleH >= scaleW ? scaleH: scaleW
            let pointSize = CGSize(width: 2.5 + scale*5.5, height: 2.5+scale*5.5)
            
            //create new drawing with default width of 10 and white strokes
            var newDrawingStrokes = [PKStroke]()
            for stroke in canvasView.drawing.strokes {
                var newPoints = [PKStrokePoint]()
                stroke.path.forEach { (point) in
                    let newPoint = PKStrokePoint(location: point.location, timeOffset: point.timeOffset, size: pointSize, opacity: CGFloat(2), force: point.force, azimuth: CGFloat.zero, altitude: CGFloat.pi/2)
                    newPoints.append(newPoint)
                }
                let newPath = PKStrokePath(controlPoints: newPoints, creationDate: Date())
                newDrawingStrokes.append(PKStroke(ink: PKInk(.pen, color: UIColor.white), path: newPath))
            }
            let newDrawing = PKDrawing(strokes: newDrawingStrokes)
            var image = newDrawing.image(from: newDrawing.bounds, scale: 5.0)
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

//    @Binding var canvasView: PKCanvasView
    @ObservedObject var labelScores: LabelScores
    
//    #if os(iOS)
//    let pencilInteraction = UIPencilInteraction()
//    #endif

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
//        #if os(iOS)
//        self.pencilInteraction.delegate = context.coordinator
//        self.canvasView.addInteraction(self.pencilInteraction)
//        #endif
        
        return canvasView
    }

    func updateUIView(_ canvasView: PKCanvasView, context: Context) {
//        canvasView.tool = PKInkingTool(.pen, width: 15)
        
        if self.labelScores.scores.isEmpty {
            canvasView.drawing = PKDrawing()
        }
    }
    
}
