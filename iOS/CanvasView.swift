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
    @State var showAboutView = false
    
    @EnvironmentObject private var tabController: TabController
    
    @State var canvas = PKCanvasView()
    
    var body: some View {
        NavigationView {
            VStack (spacing:0) {
                ZStack {
                    PKCanvas(canvasView: $canvas, labelScores: labelScores)
                        .environmentObject(symbols)
                        .frame(minWidth: 150, idealWidth: 300, maxWidth: 600, minHeight: 100, idealHeight: 200, maxHeight: 400, alignment: .center)
                        .aspectRatio(1.5, contentMode: .fit)
                        .cornerRadius(5)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10, style: .continuous)
                                .stroke(Color.blue, lineWidth: 3)
                            )
                        .padding(.init(top: 10, leading: 10, bottom: 20, trailing: 10))
                    }
                    .overlay( Group {
                        if !labelScores.scores.isEmpty {
                            ZStack {
                                Button(
                                    role: .destructive,
                                    action: {
                                        labelScores.ClearScores()
                                    },
                                    label: {
                                        Image(systemName: "clear.fill")
                                            .font(.title)
                                            .foregroundColor(.red)
                                    }
                                )
                                .padding(15)
                            }
                            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
                        }
                    })
                
                Divider()

                ZStack {
                    List {
                        ForEach(labelScores.scores, id: \.key) { key, value in
                            RowView(symbol: symbols.AllSymbols.first(where: {$0.id==key})! )
                                .onDrag { NSItemProvider(object: symbols.AllSymbols.first(where: {$0.id==key})!.command as NSString) }
                            }
                        }
                        .listStyle(InsetListStyle())
                        .frame(maxHeight:.infinity)
                    
                    Text("Draw in the canvas above")
                        .font(.system(.title, design: .rounded))
                        .frame(maxHeight:.infinity)
                        .opacity(labelScores.scores.isEmpty ? 1 : 0)
                    }
                }

            .navigationBarItems(trailing: Button(action: {self.showAboutView.toggle()}) {
                    #if targetEnvironment(macCatalyst)
                    #else
                        Image(systemName: "questionmark.circle")
                            .font(.title3)
                            .accessibility(label: Text("About"))
                    #endif
                }
            )
            .navigationTitle("Draw")
            .sheet(isPresented: $showAboutView, onDismiss: { tabController.open(.draw) }) { AboutView() }
        }
        .navigationViewStyle(StackNavigationViewStyle())
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
