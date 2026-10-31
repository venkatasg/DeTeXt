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
    @State private var showAboutView = false

    var body: some View {
        TabView(selection: $selectedTabIndex) {
            Tab("Draw", systemImage: "scribble", value: 0){
                CanvasView(symbols: symbols, labelScores: labelScores, showAboutView: $showAboutView)
            }

            Tab("Search", systemImage: "magnifyingglass", value: 1) {
                SearchView(symbols: symbols, presentSearch: $presentSearch, showAboutView: $showAboutView)
            }

        }
        .tabBarMinimizeBehavior(.never)
        #if !targetEnvironment(macCatalyst)
        .sheet(isPresented: $showAboutView) { AboutView() }
        #endif
    }
}

#Preview {
    @Previewable @State var presentSearch = false
    @Previewable @State var selectedTabIndex = 0
    
    MainView(
        selectedTabIndex: $selectedTabIndex,
        presentSearch: $presentSearch,
        labelScores: LabelScores(),
        symbols: Symbols()
    )
}
