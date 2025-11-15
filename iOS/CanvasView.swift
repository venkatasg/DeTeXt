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
        
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                ZStack(alignment: .topTrailing) {
                    PKCanvas(labelScores: labelScores)
                        .aspectRatio(1.5, contentMode: .fit)
                        .overlay(
                            RoundedRectangle(cornerRadius: 20, style: .continuous)
                                .stroke(Color.accentColor, lineWidth: 3)
                        )
                        .padding(10)
                    
                    if !labelScores.scores.isEmpty {
                        Button(role: .destructive, action: labelScores.clearScores) {
#if targetEnvironment(macCatalyst)
                            Text("Clear")
                                .font(.title)
#else
                            Image(systemName: "xmark.circle.fill")
                                .font(.title)
                                .foregroundColor(.red)
#endif
                        }
                        .padding(15)
                    }
                }
                
                Divider()
                
                if labelScores.scores.isEmpty {
                    Text("Draw in the canvas above")
                        .font(.system(.title, design: .rounded))
                        .frame(maxHeight: .infinity)
                } else {
                    List {
                        ForEach(labelScores.scores, id: \.key) { key, value in
                            RowView(
                                symbol: symbols.AllSymbols.first(where: { $0.id == key })!,
                                toastManager: toastManager
                            )
                            .onDrag {
                                NSItemProvider(
                                    object: symbols.AllSymbols.first(where: { $0.id == key })!.command as NSString
                                )
                            }
                        }
                    }
                    .listStyle(InsetListStyle())
                }
            }
            #if targetEnvironment(macCatalyst)
            .navigationTitle("")
            #else
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { self.showAboutView.toggle() }) {
                        Image(systemName: "questionmark.circle")
                            .font(.title3)
                            .accessibility(label: Text("About"))
                    }
                }
            }
            .navigationTitle("Draw")
            .sheet(isPresented: $showAboutView) { AboutView() }
            #endif
        }
    }
}

struct CanvasView_Previews: PreviewProvider {
    static let labelScores = LabelScores()
    static let symbols = Symbols()
    
    static var previews: some View {
        Group {
            CanvasView(symbols: symbols, labelScores: labelScores)
        }
    }
}
