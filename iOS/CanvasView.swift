//
//  CanvasView.swift
//  DeTeXt
//
//  Created by Venkat on 27/8/20.
//

import SwiftUI
import PencilKit

struct CanvasView: View {
    
    @ObservedObject var labelScores: LabelScores
    @ObservedObject var symbols: Symbols
    
    @State var canvas = PKCanvasView()
    
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
                        if !labelScores.scores.isEmpty {
                            ZStack {
                                Button(action:
                                        { labelScores.ClearScores() })
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
                    if labelScores.scores.isEmpty {
                        Text("Draw in the canvas above")
                            .font(.system(.title, design: .rounded))
                            .frame(maxHeight:.infinity)
                    }
                    else {
                        List {
                            ForEach(labelScores.scores, id: \.key) { key, value in
                                RowView(symbol: symbols.AllSymbols.first(where: {$0.id==key})!, confidence: (value*100) )
                                    .onDrag { NSItemProvider(object: symbols.AllSymbols.first(where: {$0.id==key})!.command as NSString) }
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
    static let labelScores = LabelScores()
    static var previews: some View {
        Group {
            CanvasView(labelScores: labelScores, symbols: symbols)
        }
    }
}
