//
//  SearchView.swift
//  DeTeXt
//
//  Created by Venkat on 10/9/20.
//

import SwiftUI

struct SearchView: View {
    
    let symbols: Symbols
    @Binding var presentSearch: Bool
    @Binding var showAboutView: Bool
    @State private var searchText = ""
    @State private var toastManager = ToastManager()
        
    var body: some View {
        // localizedStandardContains is case- and diacritic-insensitive, so no lowercased copies are needed
        let filteredSymbols = searchText.isEmpty ? symbols.AllSymbols : symbols.AllSymbols.filter {
            $0.command.localizedStandardContains(searchText) || ($0.package?.localizedStandardContains(searchText) ?? false)
        }

        NavigationStack {
            List(filteredSymbols) { symbol in
                RowView(symbol: symbol, toastManager: toastManager)
                    .onDrag { NSItemProvider(object: symbol.command as NSString) }
                }
                .listStyle(InsetListStyle())
                .toast(using: toastManager)
                .autocorrectionDisabled(true)
                .textInputAutocapitalization(.never)
                #if !targetEnvironment(macCatalyst)
                .navigationTitle("Search")
                .toolbar{
                    Button(action: {self.showAboutView.toggle()}) {
                        Image(systemName: "questionmark.circle")
//                            .font(.title3)
                            .accessibility(label: Text("About"))
                    }
                }
                #endif
                .searchable(
                    text: $searchText,
                    isPresented: $presentSearch,
                    placement: .navigationBarDrawer(displayMode: .always),
                    prompt: "Search by command or package"
                )
        }
    }
}

#Preview {
    @Previewable @State var presentSearch = false
    @Previewable @State var showAboutView = false
    SearchView(
        symbols: Symbols(), presentSearch: $presentSearch, showAboutView: $showAboutView
        )
    }
