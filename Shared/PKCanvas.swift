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
    class Coordinator: NSObject, PKCanvasViewDelegate, UIPencilInteractionDelegate {
        var pkCanvas: PKCanvas
        @ObservedObject var labelScores: LabelScores
        
        let model: deTeXq = {
            do {
                let config = MLModelConfiguration()
                return try deTeXq(configuration: config)
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
        
        func pencilInteractionDidTap(_ interaction: UIPencilInteraction) {
            // Clear the drawing when double tapped on pencil
            self.pkCanvas.canvasView.drawing = PKDrawing()
            self.labelScores.isCanvasClear = true
            self.labelScores.scores = [Dictionary<String, Double>.Element]()
        }

        func canvasViewDrawingDidChange(_ canvasView: PKCanvasView) {
            // if canvasView is empty escape gracefully
            if canvasView.drawing.bounds.isEmpty { }
            else {
                // haptic feedback
                modelHaptics()
                
                // Find the scaling factor for drawings and appropriate pointsize
                let scaleH = canvasView.drawing.bounds.size.width / canvasView.frame.width
                let scaleW = canvasView.drawing.bounds.size.height / canvasView.frame.height
                let scale = scaleH >= scaleW ? scaleH: scaleW
                let pointSize = CGSize(width: 2.5 + scale*5.5, height: 2.5+scale*5.5)
                print(pointSize)
                
                labelScores.isCanvasClear = false
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
                let processed_image = overlayBlackBg(image: image)
                predictImage(image: processed_image)
            }
        }
        
        // find the most likely class labels corresponding to the drawing
        func predictImage(image: UIImage) {
            if let resizedImage = image.resize(newSize: trainedImageSize), let pixelBuffer = resizedImage.toCVPixelBuffer() {
                guard let result = try? model.prediction(drawing: pixelBuffer) else {
                        print("error in image...")
                        return
                    }
                labelScores.scores = Array(result.classLabelProbs.sorted { $0.1 > $1.1 } [..<20])
            }
        }
    }

    @Binding var canvasView: PKCanvasView
    @ObservedObject var labelScores: LabelScores
    let pencilInteraction = UIPencilInteraction()

    func makeCoordinator() -> Coordinator {
        Coordinator(self, labelScores: labelScores)
    }

    func makeUIView(context: Context) -> PKCanvasView {
        self.canvasView.tool = PKInkingTool(.pen, width: 15)
        self.canvasView.isOpaque = true
        self.canvasView.isScrollEnabled = false
        self.canvasView.becomeFirstResponder()
        self.canvasView.delegate = context.coordinator
        self.canvasView.drawingPolicy = .anyInput
        
        self.pencilInteraction.delegate = context.coordinator
        self.canvasView.addInteraction(self.pencilInteraction)
        
        return canvasView
    }

    func updateUIView(_ canvasView: PKCanvasView, context: Context) {
        self.canvasView.tool = PKInkingTool(.pen, width: 15)
    }
}
