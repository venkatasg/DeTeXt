//
//  macCanvasVuew.swift
//  iOS
//
//  Created by Venkat on 12/9/20.
//

import SwiftUI

import SwiftUI
import PencilKit

//class LabelScores: ObservableObject {
//    @Published var scores = [Dictionary<String, Double>.Element]()
//    @Published var isCanvasClear: Bool = true
//}

struct macCanvasView: View {
    
    @State private var canvas = PKCanvasView()
    @State var searchText = ""
    @EnvironmentObject var symbols: Symbols
    @ObservedObject var labelScores: LabelScores = LabelScores()
    
    var body: some View {
        NavigationView {
            HStack(spacing: 0) {
                ZStack {
                    PKCanvas(canvasView: $canvas, labelScores: labelScores)
                        .environmentObject(symbols)
                        .frame(minWidth: 300, idealWidth: 600, maxWidth: 600, minHeight: 200, idealHeight: 400, maxHeight: 400, alignment: .center)
                        .aspectRatio(1.5, contentMode: .fit)
                        .cornerRadius(15)
                        .overlay(
                            RoundedRectangle(cornerRadius: 15)
                                .stroke(Color.blue, lineWidth: 3)
                            )
                        .padding(10)
                }
                .padding(.top, 10)
                .padding(.bottom, 10)

                Divider()

                ZStack {
                if labelScores.isCanvasClear {
                    Text("Draw in the canvas to the left")
                        .font(.system(.title, design: .rounded))
//                        .frame(maxHeight:.infinity)
                }
                else {
                    List {
                        ForEach(labelScores.scores, id: \.key) { key, value in
                            RowView(symbol: symbols.AllSymbols.first(where: {$0.id==key})!, confidence: (value*100) )
                        }
                    }
                    .listStyle(InsetListStyle())
                    .frame(maxHeight:.infinity)
                    .padding(0)
                }
                }
                .padding(0)
                .animation(.linear)
            }
            .navigationTitle("")
            .toolbar(content: {
                ToolbarItem(placement: .cancellationAction) {
                    Button(action: clearCanvas) { Text("Clear").padding(8)
                    }
                }
            })
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
    
    private func clearCanvas() {
        self.canvas.drawing = PKDrawing()
        labelScores.isCanvasClear = true
        labelScores.scores = [Dictionary<String, Double>.Element]()
    }
}

struct macCanvasView_Previews: PreviewProvider {
    static let symbols = Symbols()
    static var previews: some View {
        Group {
            macCanvasView()
                .environmentObject(symbols)
        }
    }
}

