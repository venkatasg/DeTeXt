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
    @Binding var showAboutView: Bool
    @State private var toastManager = ToastManager()
    
        
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                ZStack(alignment: .topTrailing) {
                    PKCanvas(labelScores: labelScores)
                        .aspectRatio(1.5, contentMode: .fit)
                        .cornerRadius(20)
                        .overlay(
                            RoundedRectangle(cornerRadius: 20, style: .continuous)
                                .stroke(Color.accentColor, lineWidth: 3)
                        )
                        .padding(10)
                        .overlay(alignment: .topTrailing) {
                            // Scores are only populated once something has been drawn
                            if !labelScores.scores.isEmpty {
                                Button(action: labelScores.clearScores) {
                                    Image(systemName: "xmark.circle.fill")
                                        .font(.title)
                                }
                                .tint(.red)
                                .padding(15)
                                .padding(5)
                            }
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
                            if let symbol = symbols.find(withID: key) {
                                RowView(symbol: symbol, toastManager: toastManager)
                                    .onDrag {
                                        NSItemProvider(object: symbol.command as NSString)
                                    }
                            }
                        }
                    }
                    .listStyle(InsetListStyle())
                    .frame(maxHeight:.infinity)
                    .toast(using: toastManager)
                }
            }
            #if !targetEnvironment(macCatalyst)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { self.showAboutView.toggle() }) {
                        Image(systemName: "questionmark.circle")
                            .accessibility(label: Text("About"))
                    }
                }
            }
            .navigationTitle("Draw")
            #endif
        }
    }
}

#Preview {
    @Previewable @State var showAboutView = false
    CanvasView(symbols: Symbols(), labelScores: LabelScores(), showAboutView: $showAboutView)
}
