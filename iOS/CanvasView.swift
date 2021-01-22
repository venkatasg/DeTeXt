//
//  CanvasView.swift
//  DeTeXt
//
//  Created by Venkat on 27/8/20.
//

import SwiftUI
import PencilKit

class LabelScores: ObservableObject {
    @Published var scores = [Dictionary<String, Double>.Element]()
    @Published var isCanvasClear: Bool = true
}

struct CanvasView: View {
    
    @State private var canvas = PKCanvasView()
    @EnvironmentObject var symbols: Symbols
    @ObservedObject var labelScores: LabelScores = LabelScores()
    
    var body: some View {
            VStack (spacing:0) {
                    ZStack {
                        PKCanvas(canvasView: $canvas, labelScores: labelScores)
                            .environmentObject(symbols)
                            .frame(minWidth: 150, idealWidth: 300, maxWidth: 600, minHeight: 100, idealHeight: 200, maxHeight: 400, alignment: .center)
                            .aspectRatio(1.5, contentMode: .fit)
                            .cornerRadius(5)
                            .overlay(
                                RoundedRectangle(cornerRadius: 15)
                                    .stroke(Color.blue, lineWidth: 3)
                                )
                            .padding(10)
                    }
                    .overlay( Group {
                        if !labelScores.isCanvasClear {
                            ZStack {
                                Button(action:
                                        {   self.canvas.drawing = PKDrawing()
                                            labelScores.isCanvasClear = true
                                            labelScores.scores = [Dictionary<String, Double>.Element]() })
                                            { Image(systemName: "xmark.circle.fill")
                                                .font(.title)
                                                .foregroundColor(.red)}
                                            .padding(15)
                            }
                            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
                        }
                    })
                    .padding(.bottom, 20)
                
                Divider()

                ZStack {
                if labelScores.isCanvasClear {
                    Text("Draw in the canvas above")
                        .font(.system(.title, design: .rounded))
                        .frame(maxHeight:.infinity)
                }
                else {
                    List {
                        ForEach(labelScores.scores, id: \.key) { key, value in
                            RowView(symbol: symbols.AllSymbols.first(where: {$0.id==key})!, confidence: (value*100) )
                        }
                    }
                    .listStyle(InsetListStyle())
                    .frame(maxHeight:.infinity)
                }
                }
                .animation(.easeInOut)
            }
            .navigationTitle("Draw")
    
        }
}

struct CanvasView_Previews: PreviewProvider {
    static let symbols = Symbols()
    static var previews: some View {
        Group {
            CanvasView()
                .environmentObject(symbols)
        }
    }
}
