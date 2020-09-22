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
//    @ObservedObject var settings: AppSettings = AppSettings()

    var body: some Scene {
        WindowGroup {
            MainView()
                .environmentObject(symbols)
//                .environmentObject(settings)
//                .preferredColorScheme(userInterfaceColorScheme(theme: settings.userTheme))
        }
    }
}

struct MainView: View {
    
    @State private var selection: String = "draw"
    @EnvironmentObject var symbols: Symbols
//    @EnvironmentObject var settings: AppSettings
    
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
//                .environmentObject(settings)
                .tabItem {
                    Image(systemName: "questionmark.circle.fill")
                    Text("About")
                }
                .tag("about")
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static let symbols = Symbols()
//    static var settings: AppSettings = AppSettings()
    static var previews: some View {
        Group {
            MainView()
                .previewLayout(.device)
                .environmentObject(symbols)
//                .environmentObject(settings)
                .previewDevice("iPhone 11 Pro Max")
                
        }
    }
}

