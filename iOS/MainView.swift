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
@Observable
class TabController {
    var activeTab = Tab.draw
    
    func open(_ tab: Tab) {
        activeTab = tab
    }
}

struct MainView: View {
    
    @State private var tabController = TabController()
    
    var labelScores: LabelScores
    let symbols: Symbols
        
    var body: some View {
        TabView(selection: $tabController.activeTab) {
            CanvasView(symbols: symbols, labelScores: labelScores)
                .tag(Tab.draw)
                .tabItem {
                    Image(systemName: "scribble")
                        .accessibility(label: Text("Draw symbols"))
                        .accessibility(hint: Text("Search the entire list of 1098 LaTeX symbols by drawing on a canvas."))
                    Text("Draw")
                }
                .environment(tabController)
            
            SearchView(symbols: symbols)
                .tag(Tab.search)
                .tabItem {
                    Image(systemName: "magnifyingglass")
                        .accessibility(label: Text("Search symbols"))
                        .accessibility(hint: Text("Search the entire list of 1098 LaTeX symbols by name."))
                    Text("Search")
                }
                .environment(tabController)
        }
        .onAppear() {
            let appearance = UITabBarAppearance()
            UITabBar.appearance().scrollEdgeAppearance = appearance
        }
    }
}

struct MainView_Previews: PreviewProvider {
    
    static let labelScores = LabelScores()
    static let symbols = Symbols()
    static var previews: some View {
        Group {
            MainView(labelScores: labelScores, symbols: symbols)
        }
    }
}
