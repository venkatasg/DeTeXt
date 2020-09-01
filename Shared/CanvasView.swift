//
//  CanvasView.swift
//  DeTeXt
//
//  Created by Venkat on 27/8/20.
//

import SwiftUI
import PencilKit
import CoreML

struct CanvasView: View {
    
    @State var showAboutView = false
    @State private var canvas = PKCanvasView()
    @Environment(\.colorScheme) var colorScheme

    
    var body: some View {
        NavigationView {
            VStack{
                PKCanvas(canvasView: $canvas).aspectRatio(1, contentMode: .fit).cornerRadius(25).overlay(
                    RoundedRectangle(cornerRadius: 25)
                    .stroke(lineWidth: 5) .fill((colorScheme == .light ? Color.black : Color.white))
                ).padding(16)
                Spacer()
                Text("Prediction 1").padding(8)
                Text("Prediction 2").padding(8)
                Text("Prediction 3").padding(8)
                Spacer()
            }

                .navigationBarItems(leading: Button(action: { self.canvas.drawing = PKDrawing() }) {
                        Text("Clear")
//                            .font(.body)
                            .padding(8)
                    },
                trailing:
                    Button(action: {self.showAboutView.toggle()}) {
                        Text("About")
//                            .font(.body)
                            .padding(8)
                    }
                )
                .navigationBarTitle("", displayMode: .inline)
        }.sheet(isPresented: $showAboutView) {
            AboutView()
        }
    }
    
    func detect() {
        print("Detecting!")
//        let image = canvas.preprocessImage()
//        canvas.predictImage(image: image)
    }
    
    // overlays image in a new canvas
//    func preprocessImage() -> UIImage {
//        let image = canvas.drawing.image(from: canvas.drawing.bounds, scale: 5.0)
//        var resizedImage = image.resize(newSize: trainedImageSize)!
//        if let newImage = UIImage(color: .black, size: trainedImageSize) {
//            if let overlayedImage = newImage.image(byDrawingImage: resizedImage, inRect: CGRect(x: trainedImageSize.width/2, y: trainedImageSize.height/2, width: trainedImageSize.width, height: trainedImageSize.height)){
//                resizedImage = overlayedImage
//            }
//        }
//        let finalImage = resizedImage.resize(newSize: trainedImageSize)!
//        return finalImage
//    }
//
//    // predict most likely classes
//    func predictImage(image: UIImage) {
//        if let pixelBuffer = image.toCVPixelBuffer() {
//            guard let result = try? mlmodel.prediction(drawing: pixelBuffer) else {
//                print("error in image...")
//                return
//                }
//            print(result.classLabel)
//            let sortedClassProbs = result.classLabelProbs.sorted { $0.1 > $1.1 }
//            print(sortedClassProbs[0], sortedClassProbs[1], sortedClassProbs[2])
//        }
//    }
}

struct PKCanvas: UIViewRepresentable {
    class Coordinator: NSObject, PKCanvasViewDelegate {
        var pkCanvas: PKCanvas

        init(_ pkCanvas: PKCanvas) {
            self.pkCanvas = pkCanvas
        }
        
        func canvasViewDidEndUsingTool(_ canvasView: PKCanvasView) {
            ///YESS you need to call the detection here
            
            print("Changed")
            }
    }

    @Binding var canvasView: PKCanvasView
    @Environment(\.colorScheme) var colorScheme
    private let trainedImageSize = CGSize(width: 300, height: 200)

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    func makeUIView(context: Context) -> PKCanvasView {
        self.canvasView.backgroundColor = (colorScheme == .light ? .white : .black)
        self.canvasView.tool = PKInkingTool(.pen, color: (colorScheme == .light ? .black : .white), width: 10)
        self.canvasView.isScrollEnabled = false
        self.canvasView.becomeFirstResponder()
        self.canvasView.delegate = context.coordinator
        
        if #available(iOS 14.0, *) {
            // Both finger and pencil are always allowed on this canvas.
            self.canvasView.drawingPolicy = .anyInput
        }
        else {
            self.canvasView.allowsFingerDrawing = true
        }
        
        return canvasView
    }

    func updateUIView(_ canvasView: PKCanvasView, context: Context) {
        canvasView.backgroundColor = (colorScheme == .light ? .white : .black)
        canvasView.tool = PKInkingTool(.pen, color: (colorScheme == .light ? .black : .white), width: 10)
    }
}

struct CanvasView_Previews: PreviewProvider {
    static var previews: some View {
        CanvasView()
            .previewDevice("iPhone 11 Pro Max")
    }
}
