//
//  CanvasView.swift
//  DeTeXt
//
//  Created by Venkat on 27/8/20.
//

import SwiftUI
import PencilKit
import CoreML
import Combine

class LabelScores: ObservableObject {
    @Published var scores = [Dictionary<String, Double>.Element]()
    @Published var clear: Bool = true
}

struct MainView: View {
    
    @State private var selection: String = "draw"
    @EnvironmentObject var symbols: Symbols
    
    var body: some View {
        TabView(selection: $selection) {
            CanvasView()
                .environmentObject(symbols)
                .tabItem {
                    Image(systemName: "scribble")
                    Text("Draw")
                }
                .tag("draw")
            SymbolsView()
                .environmentObject(symbols)
                .tabItem {
                    Image(systemName: "magnifyingglass")
                    Text("Search")
                }
                .tag("search")
                .padding(0)
        }
        .padding(0)
    }
}

struct CanvasView: View {
    
    @State private var presentTip = true
    @State var showAboutView = false
    @State private var canvas = PKCanvasView()
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var symbols: Symbols
    @ObservedObject var labelScores: LabelScores = LabelScores()
    
    var body: some View {
        NavigationView {
            VStack (spacing:0) {
                ZStack {
                    PKCanvas(canvasView: $canvas, labelScores: labelScores)
                        .environmentObject(symbols)
                        .aspectRatio(1.5, contentMode: .fit)
                        .cornerRadius(15)
                        .overlay(
                            RoundedRectangle(cornerRadius: 15)
                                .stroke(Color.blue, lineWidth: 2)
                            )
                        .padding(8)

//                    if self.presentTip {
//                    Text("Draw here!").font(.system(.title, design: .rounded))
//                        .frame(maxWidth: .infinity, maxHeight: .infinity)
//                        .onAppear(perform: {
//                            Timer.scheduledTimer(withTimeInterval: 2, repeats: false) { timer in
//                                withAnimation(.easeInOut(duration: 1)) {
//                                    self.presentTip.toggle()
//                                }
//                            }
//                        }
//                        )
//                    }
                }
                .padding(.top, 8)
                .padding(.bottom, 8)
                .background(Color("Background"))
                if labelScores.clear {
                    Spacer()
                        .frame(maxHeight:.infinity)
                }
                else {
                    List {
                        ForEach(labelScores.scores, id: \.key) { key, value in
                            RowView(symbol: symbols.AllSymbols.first(where: {$0.id==key})!, confidence: (value*100) )
                        }
                    }
                    .listStyle(InsetListStyle())
                }
            }
            .navigationBarItems(leading: Button(action: {
                                            self.canvas.drawing = PKDrawing()
                                            labelScores.clear = true
                                            labelScores.scores = [Dictionary<String, Double>.Element]()
                                            })
                                            { Text("Clear").padding(8)},
                                trailing: Button(action: {self.showAboutView.toggle()})
                                            { Text("About").padding(8) })
            .navigationBarTitle("", displayMode: .inline)
        }
        .sheet(isPresented: $showAboutView) { AboutView() }
    }
}

struct PKCanvas: UIViewRepresentable {
    class Coordinator: NSObject, PKCanvasViewDelegate {
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
        
        func canvasViewDrawingDidChange(_ canvasView: PKCanvasView) {
            // if canvasView is empty escape gracefully
            if canvasView.drawing.bounds.isEmpty { }
            else {
                labelScores.clear = false
                //create new drawing with default width of 10 and white strokes
                var newDrawingStrokes = [PKStroke]()
                for stroke in canvasView.drawing.strokes {
                    var newPoints = [PKStrokePoint]()
                    stroke.path.forEach { (point) in
                        let newPoint = PKStrokePoint(location: point.location, timeOffset: point.timeOffset, size: CGSize(width: 5,height: 5), opacity: CGFloat(2), force: point.force, azimuth: point.azimuth, altitude: point.altitude)
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

    func makeCoordinator() -> Coordinator {
        Coordinator(self, labelScores: labelScores)
    }

    func makeUIView(context: Context) -> PKCanvasView {
        self.canvasView.tool = PKInkingTool(.pen, width: 15)
        self.canvasView.isOpaque = true
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
        self.canvasView.tool = PKInkingTool(.pen, width: 15)
    }
}

struct CanvasView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            MainView()
                .previewDevice("iPhone 11")
                
                
        }
    }
}
