//
//  SearchView.swift
//  DeTeXt
//
//  Created by Venkat on 10/9/20.
//

import SwiftUI

struct SearchView: View {
    
    @State var searchText = ""
    @Environment(\.colorScheme) var colorScheme
    @ObservedObject var symbols: Symbols
    @State var showAboutView = false
        
    var body: some View {
            VStack(spacing: 0) {
                SearchBar(text: $searchText)
                    .padding(.top, 8)
                    .padding(.bottom, 8)
                Divider()
                List(symbols.AllSymbols.filter({searchText.isEmpty ? true : ($0.command.lowercased().contains(searchText.lowercased()) || $0.package?.lowercased().contains(searchText.lowercased()) ?? false  )})) { symbol in
                    RowView(symbol: symbol)
                        .onDrag { NSItemProvider(object: symbol.command as NSString) }
                }
                .listStyle(InsetListStyle())
            }
            .navigationBarItems(trailing: Button(action: {self.showAboutView.toggle()}) {
                Image(systemName: "questionmark.circle")
                    .font(.title2)
                    .accessibility(label: Text("About"))
                }
            )
            .navigationTitle("Search")
            .sheet(isPresented: $showAboutView) { AboutView() }
    }
}

struct SearchBar: View {
    
    @Binding var text: String
    @State private var isEditing = false
 
    var body: some View {
        HStack {
            TextField("Search by command or package", text: $text)
                .padding(7)
                .padding(.horizontal, 25)
                .background(Color(.systemGray6))
                .cornerRadius(8)
                .overlay(
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.gray)
                            .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                            .padding(.leading, 8)
                 
                        if isEditing {
                            Button(action: {
                                self.text = ""
                            }) {
                                Image(systemName: "multiply.circle.fill")
                                    .foregroundColor(.gray)
                                    .padding(.trailing, 8)
                            }
                        }
                    }
                )
                .padding(.horizontal, 10)
                .onTapGesture {
                    self.isEditing = true
                }
                .disableAutocorrection(true)
 
            if isEditing {
                Button(action: {
                    self.isEditing = false
                    self.text = ""
                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
 
                }) {
                    Text("Cancel")
                    }
                    .padding(.trailing, 10)
                    .transition(.move(edge: .trailing))
                    .animation(.easeInOut(duration: 0.2))
            }
        }
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
