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
    @State private var toastManager = ToastManager()
        
    var body: some View {
        let filteredSymbols = symbols.AllSymbols.filter({
            searchText.isEmpty ? true : ($0.command.lowercased().contains(searchText.lowercased()) || $0.package?.lowercased().contains(searchText.lowercased()) ?? false)
        })

        NavigationStack {
            List(filteredSymbols) { symbol in
                RowView(symbol: symbol, toastManager: toastManager)
                    .onDrag { NSItemProvider(object: symbol.command as NSString) }
                }
                .listStyle(InsetListStyle())
                .toast(using: toastManager)
                .autocorrectionDisabled(true)
                .textInputAutocapitalization(.never)
            
            #if targetEnvironment(macCatalyst)
                .navigationTitle("")
            #else
                .navigationTitle("Search")
                .toolbar{
                    Button(action: {self.showAboutView.toggle()}) {
                        Image(systemName: "questionmark.circle")
                            .font(.title3)
                            .accessibility(label: Text("About"))
                    }
                }
                .sheet(isPresented: $showAboutView) { AboutView() }
            #endif
        }
        .searchable(
            text: $searchText,
            placement: .toolbar,
            prompt: "Search by command or package"
        )
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
