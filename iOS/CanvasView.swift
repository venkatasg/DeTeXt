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
    
    // variables for search functionality
    @Binding var searchText: String
    @Environment(\.isSearching) private var isSearching

        
    var body: some View {
            if !isSearching {
                DrawView(symbols: symbols, labelScores: labelScores, toastManager: toastManager)
                    .toolbar {
                        Button(action: {self.showAboutView.toggle()}) {
                            Image(systemName: "questionmark.circle")
                                .font(.title3)
                                .accessibility(label: Text("About"))
                        }
                    }
                    .sheet(isPresented: $showAboutView) { AboutView() }
            }
            else {
                SearchPopView(symbols: symbols, toastManager: toastManager, searchText: $searchText)
            }
        
    }
}

struct DrawView: View {
    
    let symbols: Symbols
    var labelScores: LabelScores
    var toastManager: ToastManager
    
    var body: some View {
        VStack (spacing:0) {
            ZStack {
                PKCanvas(labelScores: labelScores)
                    .frame(minWidth: 150, idealWidth: 300, maxWidth: 600, minHeight: 100, idealHeight: 200, maxHeight: 400, alignment: .center)
                    .aspectRatio(1.5, contentMode: .fit)
//                        .cornerRadius(5)
                    .overlay {
                        RoundedRectangle(
                            cornerRadius: 20,
                            style: .continuous
                        )
                        .stroke(Color.accentColor, lineWidth: 3)
                    }
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
                                    #else
                                        Image(systemName: "xmark.circle.fill")
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
                            .onDrag { NSItemProvider(object: symbols.AllSymbols.first(where: {$0.id==key})!.command as NSString) }
                        }
                    }
                .listStyle(.plain)
                    .frame(maxHeight:.infinity)
                    .toast(using: toastManager)
                
                Text("Draw in the canvas above")
                    .font(.system(.title, design: .rounded))
                    .frame(maxHeight:.infinity)
                    .opacity(labelScores.scores.isEmpty ? 1 : 0)
                }
            }
    }
}

struct SearchPopView: View {
    
    let symbols: Symbols
    let toastManager: ToastManager
    @Binding var searchText: String
            
    var body: some View {
        let filteredSymbols = symbols.AllSymbols.filter({
            searchText.isEmpty ? true : ($0.command.lowercased().contains(searchText.lowercased()) || $0.package?.lowercased().contains(searchText.lowercased()) ?? false)
        })
        
        List(filteredSymbols) { symbol in
            RowView(symbol: symbol, toastManager: toastManager)
                .onDrag { NSItemProvider(object: symbol.command as NSString) }
        }
        .listStyle(.plain)
        .scrollEdgeEffectStyle(.soft, for: .top)
        .toast(using: toastManager)
        .autocorrectionDisabled(true)
        .textInputAutocapitalization(.never)
    }
}
