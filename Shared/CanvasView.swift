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

    var predictionOne = ""
    var predictionTwo = "Draw above"
    var predictionThree = ""
    
    var body: some View {
        NavigationView {
            VStack{
                PKCanvas(canvasView: $canvas)
                    .aspectRatio(1.5, contentMode: .fit)
                    .cornerRadius(15)
                    .overlay(RoundedRectangle(cornerRadius: 25)
                    .stroke(lineWidth: 0)
                    .fill((colorScheme == .light ? Color.black : Color.white)))
                    .padding(16)
//                    .background(RoundedRectangle(cornerRadius: 10)
//                    .fill(Color.neuBackground))
                    .shadow(color: .dropShadow, radius: 15, x: 10, y: 10)
                    .shadow(color: .dropShadow, radius: 15, x: 10, y: -10)
                    .shadow(color: .dropShadow, radius: 15, x: -10, y: 10)
                    .shadow(color: .dropShadow, radius: 15, x: -10, y: -10)
                    .foregroundColor(.primary)
                Spacer()
                Text(self.predictionOne).padding(8)
                Text(self.predictionTwo).padding(8)
                Text(self.predictionThree).padding(8)
                Spacer()
            }
                .background((colorScheme == .light ? Color.neuBackground : Color.neuBackgroundDark))
                .navigationBarItems(leading: Button(action: { self.canvas.drawing = PKDrawing() }) {
                        Text("Clear")
                            .padding(8)
                    },
                trailing:
                    Button(action: {self.showAboutView.toggle()}) {
                        Text("About")
                            .padding(8)
                    }
                )
                .navigationBarTitle("", displayMode: .inline)
        }.sheet(isPresented: $showAboutView) {
            AboutView()
        }
    }
}

struct PKCanvas: UIViewRepresentable {
    class Coordinator: NSObject, PKCanvasViewDelegate {
        var pkCanvas: PKCanvas
//        let compiledUrl = try! MLModel.compileModel(at: URL(fileURLWithPath: "deTeX.mlmodel"))
//        let model = try! MLModel(contentsOf: compiledUrl)
//        @Environment(\.colorScheme) var colorScheme: ColorScheme
        let model = deTeX()
        private let trainedImageSize = CGSize(width: 300, height: 200)
        let symbols = loadJson()
        
        init(_ pkCanvas: PKCanvas) {
            self.pkCanvas = pkCanvas
        }
        
        func canvasViewDrawingDidChange(_ canvasView: PKCanvasView) {
            // if canvasView is empty escape gracefully
            if canvasView.drawing.bounds.isEmpty { }
            else {
                var image = canvasView.drawing.image(from: canvasView.drawing.bounds, scale: 5.0)
                if image.averageColor?.cgColor.components![0] == 0 {
                    image = invertColors(image: image)
                }
                let processed_image = preprocessImage(image: image)
                predictImage(image: processed_image)
            }
        }
        
        // invert the colors when in light mode
        func invertColors(image: UIImage) -> UIImage {
            let beginImage = CIImage(image: image)
            let filter = CIFilter(name: "CIColorInvert")
            filter?.setValue(beginImage, forKey: kCIInputImageKey)
            let newImage = UIImage(ciImage: (filter?.outputImage!)!)
            return newImage
        }
        
        // overlays image in a new canvas
        func preprocessImage(image: UIImage) -> UIImage {
            var resizedImage = image.resize(newSize: trainedImageSize)!
            if let newImage = UIImage(color: .black, size: trainedImageSize) {
                if let overlayedImage = newImage.image(byDrawingImage: resizedImage, inRect: CGRect(x: trainedImageSize.width/2, y: trainedImageSize.height/2, width: trainedImageSize.width, height: trainedImageSize.height)){
                    resizedImage = overlayedImage
                }
            }
            let finalImage = resizedImage.resize(newSize: trainedImageSize)!
            return finalImage
        }
        
        func predictImage(image: UIImage) {
            if let pixelBuffer = image.toCVPixelBuffer() {
                guard let result = try? model.prediction(drawing: pixelBuffer) else {
                        print("error in image...")
                        return
                    }
                let sortedClassProbs = result.classLabelProbs.sorted { $0.1 > $1.1 }
                for i in 0 ..< 3 {
                print(symbols!.first(where: {$0.id==sortedClassProbs[i].key})?.command ?? "None",
                      sortedClassProbs[i].value,
                      symbols!.first(where: {$0.id==sortedClassProbs[i].key})?.mathmode ?? "None",
                      symbols!.first(where: {$0.id==sortedClassProbs[i].key})?.textmode ?? "None",
                      symbols!.first(where: {$0.id==sortedClassProbs[i].key})?.package ?? "None",
                      symbols!.first(where: {$0.id==sortedClassProbs[i].key})?.fontenc ?? "None")
                }
            }
        }
    }

    @Binding var canvasView: PKCanvasView
//    @Environment(\.colorScheme) var colorScheme

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    func makeUIView(context: Context) -> PKCanvasView {
//        self.canvasView.backgroundColor = UIColor.systemBackground
        self.canvasView.tool = PKInkingTool(.pen, width: 15)
        self.canvasView.isScrollEnabled = false
        self.canvasView.becomeFirstResponder()
        self.canvasView.delegate = context.coordinator
        
        if #available(iOS 14.0, *) {
            self.canvasView.drawingPolicy = .anyInput
        }
        else {
            self.canvasView.allowsFingerDrawing = true
        }
        
        return canvasView
    }

    func updateUIView(_ canvasView: PKCanvasView, context: Context) {
//        self.canvasView.backgroundColor = UIColor.systemBackground
        self.canvasView.tool = PKInkingTool(.pen, width: 15)
    }
}

struct CanvasView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            CanvasView()
                .preferredColorScheme(.light)
                .previewDevice("iPhone 11 Pro Max")
        }
    }
}
