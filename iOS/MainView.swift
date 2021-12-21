//
//  MainView.swift
//  iOS
//
//  Created by Venkat on 3/10/20.
//

import SwiftUI
import UIKit

// Enumeration of two major view in app
enum Tab {
    case draw
    case search
}

// Tabcontroller controls active TabView
class TabController: ObservableObject {
    @Published var activeTab = Tab.draw
    
    func open(_ tab: Tab) {
        activeTab = tab
    }
}

struct MainView: View {
    
    @StateObject private var tabController = TabController()
    
    @ObservedObject var labelScores: LabelScores
    @ObservedObject var symbols: Symbols
    
    var body: some View {
        TabView(selection: $tabController.activeTab) {
            CanvasView(labelScores: labelScores, symbols: symbols)
                .tag(Tab.draw)
                .tabItem {
                    Image(systemName: "scribble")
                        .accessibility(label: Text("Draw symbols"))
                    Text("Draw")
                }
            
            SearchView(symbols: symbols)
                .tag(Tab.search)
                .tabItem {
                    Image(systemName: "magnifyingglass")
                        .accessibility(label: Text("Search symbols"))
                        .accessibility(hint: Text("Search the entire list of 1098 LaTeX symbols by name."))
                    Text("Search")
                }
        }
        .environmentObject(tabController)
        .onAppear() {
            let appearance = UITabBarAppearance()
            UITabBar.appearance().scrollEdgeAppearance = appearance
        }
    }
}

struct MainView_Previews: PreviewProvider {
    
    static let symbols = Symbols()
    static let labelScores = LabelScores()
    
    static var previews: some View {
        Group {
            MainView(labelScores: labelScores, symbols: symbols)
        }
    }
}
