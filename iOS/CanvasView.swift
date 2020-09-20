//
//  CanvasView.swift
//  DeTeXt
//
//  Created by Venkat on 27/8/20.
//

import SwiftUI
import PencilKit
import Combine

class LabelScores: ObservableObject {
    @Published var scores = [Dictionary<String, Double>.Element]()
    @Published var clear: Bool = true
}

struct CanvasView: View {
    
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
                                .stroke(Color.blue, lineWidth: 3)
                            )
                        .padding(10)
                }
                .padding(.top, 10)
                .padding(.bottom, 10)

                Divider()
                ZStack {
                if labelScores.clear {
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
                .transition(.move(edge: .trailing))
                .animation(.easeInOut)
            }
            .navigationBarItems(leading: Button(action: {
                                            self.canvas.drawing = PKDrawing()
                                            labelScores.clear = true
                                            labelScores.scores = [Dictionary<String, Double>.Element]()
                                            })
                                            { Text("Clear").padding(8)})
            .navigationBarTitle("DeTeXt", displayMode: .inline)
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

struct CanvasView_Previews: PreviewProvider {
    static let symbols = Symbols()
    static var previews: some View {
        Group {
            CanvasView()
                .environmentObject(symbols)
                .previewDevice("iPhone 11 Pro Max")
                
        }
    }
}
