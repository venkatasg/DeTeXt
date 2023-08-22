//
//  SearchView.swift
//  DeTeXt
//
//  Created by Venkat on 10/9/20.
//

import SwiftUI

struct SearchView: View {
    
    @State var searchText = ""
    @ObservedObject var symbols: Symbols
    @State var showAboutView = false
    
    @EnvironmentObject private var tabController: TabController
        
    var body: some View {
        NavigationView {
            List(symbols.AllSymbols.filter({searchText.isEmpty ? true : ($0.command.lowercased().contains(searchText.lowercased()) || $0.package?.lowercased().contains(searchText.lowercased()) ?? false  )})) { symbol in
                RowView(symbol: symbol)
                    .onDrag { NSItemProvider(object: symbol.command as NSString) }
                }
                .listStyle(InsetListStyle())
                .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .always))
            #if targetEnvironment(macCatalyst)
                .navigationTitle("Search")
            #else
                .navigationBarItems(trailing: Button(action: {self.showAboutView.toggle()}) {
                        Image(systemName: "questionmark.circle")
                            .font(.title3)
                            .accessibility(label: Text("About"))
                }
                )
                .navigationTitle("Search")
                .sheet(isPresented: $showAboutView, onDismiss: { tabController.open(.search) }) { AboutView() }
            #endif
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }   
}

struct SearchView_Previews: PreviewProvider {
    static let symbols = Symbols()
    static var previews: some View {
        Group {
            SearchView(symbols: symbols)
        }
    }
}
