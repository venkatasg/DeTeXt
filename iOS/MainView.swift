//
//  MainView.swift
//  iOS
//
//  Created by Venkat on 3/10/20.
//

import SwiftUI

struct MainView: View {
    
    @State private var selection: String = "draw"
    @EnvironmentObject var symbols: Symbols
    
    var body: some View {
        #if targetEnvironment(macCatalyst)
        NavigationView {
            List {
                NavigationLink(
                    destination: CanvasView()
                                    .environmentObject(symbols),
                    label: {
                        Group {
                            Image(systemName: "scribble")
                                        .accessibility(label: Text("Draw symbols"))
                            Text("Draw")
                            }
                            .font(.largeTitle)
                        })
                NavigationLink(
                    destination: SearchView()
                                    .environmentObject(symbols),
                    label: {
                        Group {
                            Image(systemName: "magnifyingglass")
                                .accessibility(label: Text("Search symbols"))
                                .accessibility(hint: Text("Search the entire list of 1098 LaTeX symbols by name."))
                            Text("Search")
                            }
                            .font(.largeTitle)
                        })
                }
                .listStyle(SidebarListStyle())
        }
        #else
        TabView(selection: $selection) {
            CanvasView()
                .environmentObject(symbols)
                .tabItem {
                    Image(systemName: "scribble")
                        .accessibility(label: Text("Draw symbols"))
                    Text("Draw")
                }
                .tag("draw")
            SearchView()
                .environmentObject(symbols)
                .tabItem {
                    Image(systemName: "magnifyingglass")
                        .accessibility(label: Text("Search symbols"))
                        .accessibility(hint: Text("Search the entire list of 1098 LaTeX symbols by name."))
                    Text("Search")
                }
                .tag("search")
            AboutView()
                .tabItem {
                    Image(systemName: "questionmark.circle")
                        .accessibility(label: Text("About"))
                    Text("About")
                }
                .tag("about")
        }
        #endif
    }
}

struct MainView_Previews: PreviewProvider {
    static let symbols = Symbols()
    static var previews: some View {
        Group {
            MainView()
                .environmentObject(symbols)
        }
    }
}
