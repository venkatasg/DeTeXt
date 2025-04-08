//
//  SearchView.swift
//  DeTeXt
//
//  Created by Venkat on 10/9/20.
//

import SwiftUI

struct SearchView: View {
    
    let symbols: Symbols
    
    @State private var searchText = ""
    @State private var showAboutView = false
    @State private var isPresented = false
    @State private var toastManager = ToastManager()
    
    #if targetEnvironment(macCatalyst)
    let rowHeight:CGFloat = 100
    #else
    let rowHeight:CGFloat = 70
    #endif
    
    @Environment(TabController.self) var tabController
        
    var body: some View {
        NavigationStack {
            List(symbols.AllSymbols.filter({searchText.isEmpty ? true : ($0.command.lowercased().contains(searchText.lowercased()) || $0.package?.lowercased().contains(searchText.lowercased()) ?? false  )})) { symbol in
                RowView(symbol: symbol, toastManager: toastManager)
                    .onDrag { NSItemProvider(object: symbol.command as NSString) }
                    .frame(minHeight: self.rowHeight)
                }
                .listStyle(InsetListStyle())
                .toast(using: toastManager)
                #if targetEnvironment(macCatalyst)
                .searchable(
                    text: $searchText,
                    isPresented: $isPresented,
                    prompt: "Search by command or package"
                )
                #else
                .searchable(
                    text: $searchText,
                    isPresented: $isPresented,
                    placement: .navigationBarDrawer(displayMode: .always),
                    prompt: "Search by command or package"
                )
                #endif
                .autocorrectionDisabled(true)
                .textInputAutocapitalization(.never)
            
            #if targetEnvironment(macCatalyst)
                .navigationTitle("")
            #else
                .toolbar{
                    Button(action: {self.showAboutView.toggle()}) {
                        Image(systemName: "questionmark.circle")
                            .font(.title3)
                            .accessibility(label: Text("About"))
                    }
                }
                .navigationTitle("Search")
                .sheet(isPresented: $showAboutView, onDismiss: { tabController.open(.search) }) { AboutView() }
            #endif
        }
    }
}

struct SearchView_Previews: PreviewProvider {
    static let tabController = TabController()
    static let symbols = Symbols()
    
    static var previews: some View {
        Group {
            SearchView(symbols: symbols)
                .environment(tabController)
        }
    }
}
