//
//  MainView.swift
//  DeTeXt Watch Extension
//
//  Created by Venkat on 5/10/20.
//

import SwiftUI

struct MainView: View {
    
    @State private var selection: String = "draw"
    @EnvironmentObject var symbols: Symbols
    
    var body: some View {
        TabView(selection: $selection) {
            CanvasView()
                .environmentObject(symbols)
                .tabItem {
                    Text("Draw")
                }
                .tag("draw")
            SearchView()
                .environmentObject(symbols)
                .tabItem {
                    Text("Search")
                }
                .tag("search")
            
            BrowseView()
                .environmentObject(symbols)
                .tabItem {
                    Text("Browse")
                }
                .tag("browse")
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
            .environmentObject(Symbols())
    }
}
