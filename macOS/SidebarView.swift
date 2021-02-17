//
//  SidebarView.swift
//  iOS
//
//  Created by Venkat on 1/28/21.
//

import SwiftUI

struct SidebarView: View {
    
    @State private var selection: String? = "draw"
    
    @ObservedObject var labelScores: LabelScores
    @ObservedObject var symbols: Symbols
    
    var body: some View {
        NavigationView {
            List {
                NavigationLink(
                    destination: CanvasView(labelScores: labelScores, symbols: symbols),
                    tag: "draw",
                    selection: self.$selection,
                    label: {
                        Group {
                            Image(systemName: "scribble")
                                        .accessibility(label: Text("Draw symbols"))
                            Text("Draw")
                        }
                        .font(.title)
                    })
                
                NavigationLink(
                    destination: SearchView(symbols: symbols),
                    tag: "search",
                    selection: self.$selection,
                    label: {
                        Group {
                            Image(systemName: "magnifyingglass")
                                .accessibility(label: Text("Search symbols"))
                                .accessibility(hint: Text("Search the entire list of 1098 LaTeX symbols by name."))
                            Text("Search")
                        }
                        .font(.title)
                    })
            }
        }
    }
}

struct SidebarView_Previews: PreviewProvider {
    
    static let symbols = Symbols()
    static let labelScores = LabelScores()
    
    static var previews: some View {
        Group {
            SidebarView(labelScores: labelScores, symbols: symbols)
        }
    }
}

