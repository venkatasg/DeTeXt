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

struct LabelScore {
    var command: String
    var cssclass: String
    var mathmode: Bool
    var textmode: Bool
    var package: String
    var fontenc: String
    var formattedConf: String = ""
    var confidence: Double {
        willSet { }
        didSet { self.formattedConf = String(format: "%.1f", self.confidence) }
    }
    
    init(command: String, cssclass:String, mathmode: Bool = false, textmode: Bool = false, package: String = "", fontenc: String = "", confidence: Double) {
        self.command = command
        self.cssclass = cssclass
        self.mathmode = mathmode
        self.textmode = textmode
        self.package = package
        self.fontenc = fontenc
        self.confidence = confidence
    }
}

class LabelScores: ObservableObject {
    @Published var scores: [LabelScore]
    @Published var clear: Bool = true
    
    init() {
        self.scores = Array(repeating: LabelScore(command: "", cssclass: "", confidence: 0), count: 50)
        
    }
}

struct CanvasView: View {
    
    @State private var presentTip = true
    @State var showAboutView = false
    @State private var canvas = PKCanvasView()
    @Environment(\.colorScheme) var colorScheme
    @ObservedObject var labelScores: LabelScores = LabelScores()

    var predictionOne = ""
    var predictionTwo = "Draw above"
    var predictionThree = ""
    
    var body: some View {
        NavigationView {
            VStack (spacing:0) {
                ZStack {
                    PKCanvas(canvasView: $canvas, labelScores: labelScores)
                        .aspectRatio(1.5, contentMode: .fit)
                        .cornerRadius(15)
                        .overlay(
                            RoundedRectangle(cornerRadius: 15)
                                .stroke(Color.blue, lineWidth: 2)
                            )
                        .padding(16)

                    if self.presentTip {
                    Text("Draw here!").font(.system(.title, design: .rounded))
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .onAppear(perform: {
                            Timer.scheduledTimer(withTimeInterval: 2, repeats: false) { timer in
                                withAnimation(.easeInOut(duration: 1)) {
                                    self.presentTip.toggle()
                                }
                            }
                        }
                        )
                    }
                }
                .padding(.top, 8)
                .padding(.bottom, 8)
                .background(Color("Background"))
                Group {
                    if labelScores.clear {
                        Spacer()
                            .frame(maxHeight:.infinity)
                    }
                    else {
                        List {
                            ForEach(0..<50) { number in
                                CommandDetailView(labelScore: labelScores.scores[number])

                            }
                        }
                        .listStyle(InsetListStyle())
//                        .scaledToFill()
//                        .clipped()
//                        .listRowInsets(EdgeInsets())
                    }
                }
            }
//          .padding(.bottom, 8)
            .navigationBarItems(leading: Button(action: {
                                            self.canvas.drawing = PKDrawing()
                                            self.labelScores.clear = true})
                                            { Text("Clear").padding(8)},
                                trailing: Button(action: {self.showAboutView.toggle()})
                                            { Text("About").padding(8) })
            .navigationBarTitle("", displayMode: .inline)
        }
        .sheet(isPresented: $showAboutView) { AboutView() }
    }
}

struct CommandDetailView: View {
    
    var labelScore: LabelScore
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        HStack {
            Image("\(labelScore.cssclass)")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width:30)
                .padding(.top,4)
                .padding(.bottom,4)
                .padding(.leading,4)
                .padding(.trailing, 8)
                .foregroundColor((colorScheme == .light ? Color.black : Color.white))
            VStack(alignment: .leading) {
                Text("\(labelScore.command)")
                    .font(.system(size: 20, weight: .bold, design: .monospaced))
                    .padding(.bottom, 4)
                    .padding(.top, 4)
                if labelScore.mathmode {
                    Text(" mathmode")
                        .font(.system(size: 14))
                        .foregroundColor(Color.gray)
                }
                else if labelScore.textmode {
                    Text(" textmode")
                        .font(.system(size: 14))
                        .foregroundColor(Color.gray)
                }
                else {}

                if labelScore.package != "" {
                    Text("\\usepackage{\(labelScore.package)}")
                        .font(.system(size: 14, design: .monospaced))
                        .foregroundColor(Color.gray)
//                        .padding(.bottom, 4)
                }
                else {}
                
            }
            Spacer()
            Text("\(labelScore.formattedConf) %")
                .font(.system(size: 20, design: .rounded))
//                .padding(4)
        }
    }
}

struct PKCanvas: UIViewRepresentable {
    class Coordinator: NSObject, PKCanvasViewDelegate {
        var pkCanvas: PKCanvas
        @ObservedObject var labelScores: LabelScores
        let model = deTeXq()
        private let trainedImageSize = CGSize(width: 300, height: 200)
        let symbols = loadJson()
        
        init(_ pkCanvas: PKCanvas, labelScores: LabelScores) {
            self.pkCanvas = pkCanvas
            self.labelScores = labelScores
        }
        
        func canvasViewDrawingDidChange(_ canvasView: PKCanvasView) {
            // if canvasView is empty escape gracefully
            if canvasView.drawing.bounds.isEmpty { }
            else {
                self.labelScores.clear = false
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

                let sortedClassProbs = result.classLabelProbs.sorted { $0.1 > $1.1 }
                for i in 0 ..< 50 {
                    if let mysymbol = symbols!.first(where: {$0.id==sortedClassProbs[i].key}) {
                        labelScores.scores[i].command = mysymbol.command
                        labelScores.scores[i].mathmode = mysymbol.mathmode
                        labelScores.scores[i].textmode = mysymbol.textmode
                        labelScores.scores[i].cssclass = mysymbol.css_class
                        labelScores.scores[i].package = mysymbol.package ?? ""
                        labelScores.scores[i].fontenc = mysymbol.fontenc ?? ""
                        labelScores.scores[i].confidence = sortedClassProbs[i].value*100
                    }
                }
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
//        self.canvasView.backgroundColor = UIColor.systemBackground
        self.canvasView.tool = PKInkingTool(.pen, width: 15)
    }
}

struct CanvasView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            CanvasView()
                .previewDevice("iPhone 11 Pro Max")
        }
    }
}
