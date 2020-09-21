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
                    Text("Draw")
                }
                .tag("draw")
            SymbolsView()
                .environmentObject(symbols)
                .tabItem {
                    Image(systemName: "magnifyingglass")
                    Text("Symbols")
                }
                .tag("search")
            SettingsView()
                .tabItem {
                    Image(systemName: "gear")
                    Text("Settings")
                }
                .tag("settings")
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static let symbols = Symbols()
    static var previews: some View {
        Group {
            MainView()
                .environmentObject(symbols)
                .previewDevice("iPhone 11 Pro Max")
                
        }
    }
}

