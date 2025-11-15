//
//  MainView.swift
//  iOS
//
//  Created by Venkat on 3/10/20.
//

import SwiftUI

struct MainView: View {
    
    @Binding var selectedTabIndex: Int
    @Binding var presentSearch: Bool
    
    var labelScores: LabelScores
    let symbols: Symbols
        
    var body: some View {
        TabView(selection: $selectedTabIndex) {
            Tab("Draw", systemImage: "scribble", value: 0){
                CanvasView(symbols: symbols, labelScores: labelScores)
            }

            Tab("Search", systemImage: "magnifyingglass", value: 1) {
                SearchView(symbols: symbols, presentSearch: $presentSearch)
            }

        }
        .tabBarMinimizeBehavior(.never)
    }
}

struct MainView_Previews: PreviewProvider {
    
    static let labelScores = LabelScores()
    static let symbols = Symbols()
    static var previews: some View {
        Group {
            MainView(
                selectedTabIndex: .constant(0),
                presentSearch: .constant(false),
                labelScores: labelScores,
                symbols: symbols
            )
        }
    }
}
