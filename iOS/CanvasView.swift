//
//  CanvasView.swift
//  DeTeXt
//
//  Created by Venkat on 27/8/20.
//

import SwiftUI
import PencilKit

struct CanvasView: View {
    
    let symbols: Symbols
    
    var labelScores: LabelScores
    @State var showAboutView = false
    @State private var toastManager = ToastManager()
    
    #if targetEnvironment(macCatalyst)
    let rowHeight:CGFloat = 100
    #else
    let rowHeight:CGFloat = 70
    @Environment(TabController.self) var tabController
    #endif
    
    var body: some View {
        NavigationStack {
            VStack (spacing:0) {
                ZStack {
                    PKCanvas(labelScores: labelScores)
                        .frame(minWidth: 150, idealWidth: 300, maxWidth: 600, minHeight: 100, idealHeight: 200, maxHeight: 400, alignment: .center)
                        .aspectRatio(1.5, contentMode: .fit)
                        .cornerRadius(5)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10, style: .continuous)
                                .stroke(Color.accentColor, lineWidth: 3)
                        )
                        .padding(.init(top: 10, leading: 10, bottom: 20, trailing: 10))
                    }
                    .overlay( Group {
                        if !labelScores.scores.isEmpty {
                            ZStack {
                                Button(
                                    role: .destructive,
                                    action: {
                                        labelScores.clearScores()
                                    },
                                    label: {
                                        #if targetEnvironment(macCatalyst)
                                            Text("Clear")
                                                .font(.title)
                                                .foregroundColor(.red)
                                        #else
                                            Image(systemName: "clear.fill")
                                                .font(.title)
                                                .foregroundColor(.red)
                                        #endif
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
                            RowView(symbol: symbols.AllSymbols.first(where: {$0.id==key})!, toastManager: toastManager)
                                .frame(minHeight:self.rowHeight)
                                .onDrag { NSItemProvider(object: symbols.AllSymbols.first(where: {$0.id==key})!.command as NSString) }
                            }
                        }
                        .listStyle(InsetListStyle())
                        .frame(maxHeight:.infinity)
                        .toast(using: toastManager)
                    
                    Text("Draw in the canvas above")
                        .font(.system(.title, design: .rounded))
                        .frame(maxHeight:.infinity)
                        .opacity(labelScores.scores.isEmpty ? 1 : 0)
                    }
                }
            #if targetEnvironment(macCatalyst)
            .navigationTitle("")
            #else
            .toolbar {
                Button(action: {self.showAboutView.toggle()}) {
                    Image(systemName: "questionmark.circle")
                        .font(.title3)
                        .accessibility(label: Text("About"))
                }
            }
            .navigationTitle("Draw")
            .sheet(isPresented: $showAboutView, onDismiss: { tabController.open(.draw) }) { AboutView() }
            #endif
        }
    }
}

struct CanvasView_Previews: PreviewProvider {
    static let labelScores = LabelScores()
    static let tabController = TabController()
    static let symbols = Symbols()
    
    static var previews: some View {
        Group {
            CanvasView(symbols: symbols, labelScores: labelScores)
                .environment(tabController)
        }
    }
}
