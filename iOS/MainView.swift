//
//  MainView.swift
//  iOS
//
//  Created by Venkat on 3/10/20.
//

import SwiftUI
import UIKit

struct MainView: View {
    
    @State private var selection: String? = "draw"
    
    @ObservedObject var labelScores: LabelScores
    @ObservedObject var symbols: Symbols
    
    var body: some View {
        TabView(selection: $selection) {
            NavigationView {
                CanvasView(labelScores: labelScores, symbols: symbols)
                }
                .navigationViewStyle(StackNavigationViewStyle())
                .tabItem {
                    Image(systemName: "scribble")
                        .accessibility(label: Text("Draw symbols"))
                    Text("Draw")
                }
                .tag("draw")
            
            NavigationView {
                SearchView(symbols: symbols)
                }
                .navigationViewStyle(StackNavigationViewStyle())
                .tabItem {
                    Image(systemName: "magnifyingglass")
                        .accessibility(label: Text("Search symbols"))
                        .accessibility(hint: Text("Search the entire list of 1098 LaTeX symbols by name."))
                    Text("Search")
                }
                .tag("search")
        }
        .onAppear() {
            UITabBar.appearance().backgroundColor = UIColor.secondarySystemBackground
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
