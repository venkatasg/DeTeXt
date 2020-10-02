//
//  DeTeXtApp.swift
//  Shared
//
//  Created by Venkat on 29/8/20.
//

import SwiftUI
import Combine

@main
struct DeTeXtApp: App {
    
    @StateObject var symbols = Symbols()

    var body: some Scene {
        WindowGroup {
            MainView()
                .environmentObject(symbols)
        }
    }
}

struct MainView: View {
    
    @State private var selection: String = "draw"
    @EnvironmentObject var symbols: Symbols
    
    var body: some View {
        TabView(selection: $selection) {
            CanvasView()
                .environmentObject(symbols)
                .tabItem {
                    Image(systemName: "scribble")
                        .accessibility(label: Text("Draw symbols."))
                    Text("Draw")
                }
                .tag("draw")
            SearchView()
                .environmentObject(symbols)
                .tabItem {
                    Image(systemName: "magnifyingglass")
                        .accessibility(label: Text("Search symbols."))
                        .accessibility(hint: Text("Search the entire list of 1098 LaTeX symbols by name."))
                    Text("Symbols")
                }
                .tag("search")
            AboutView()
                .tabItem {
                    Image(systemName: "questionmark.circle.fill")
                        .accessibility(label: Text("About"))
                    Text("About")
                }
                .tag("about")
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static let symbols = Symbols()
    static var previews: some View {
        Group {
            MainView()
                .previewLayout(.device)
                .environmentObject(symbols)
                .previewDevice("iPhone 11 Pro Max")
                
        }
    }
}

