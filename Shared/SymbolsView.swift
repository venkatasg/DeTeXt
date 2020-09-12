//
//  SymbolsView.swift
//  DeTeXt
//
//  Created by Venkat on 10/9/20.
//

import SwiftUI

struct SymbolsView: View {
    
    @State var showAboutView = false
    @State var searchText = ""
    @Environment(\.colorScheme) var colorScheme
    let symbols = Bundle.main.decode("symbols.json")
//    @ObservedObject var symbols: [Symbol]
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                SearchBar(text: $searchText)
                    .padding(.top, 8)
                    .padding(.bottom, 8)
                Divider()
                List(symbols.filter({searchText.isEmpty ? true : ($0.command.lowercased().contains(searchText.lowercased()))})) { symbol in
                    RowView(symbol: symbol)
                }
                .listStyle(InsetListStyle())
            }
            .navigationBarItems(trailing: Button(action: {self.showAboutView.toggle()})
                                            { Text("About").padding(8) })
            .navigationBarTitle("", displayMode: .inline)
        }
        .sheet(isPresented: $showAboutView) { AboutView() }
    }
}

struct SearchBar: View {
    
    @Binding var text: String
    @State private var isEditing = false
 
    var body: some View {
        HStack {
 
            TextField("Search ...", text: $text)
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
                .animation(.easeInOut)
            }
        }
    }
}

struct RowView: View {
    
    let symbol: Symbol
    @Environment(\.colorScheme) var colorScheme
    var confidence: Double?
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text("\(symbol.command)")
                    .font(.system(size: 16, weight: .bold, design: .monospaced))
                    .padding(.bottom, 4)
                    .padding(.top, 4)
                if symbol.mathmode {
                    Text(" mathmode")
                        .font(.system(size: 12))
                        .foregroundColor(Color.gray)
                }
                else if symbol.textmode {
                    Text(" textmode")
                        .font(.system(size: 12))
                        .foregroundColor(Color.gray)
                }
                else {}

                if let package = symbol.package {
                    Text("\\usepackage{\(package)}")
                        .font(.system(size: 12, design: .monospaced))
                        .foregroundColor(Color.gray)
                }
                
                
                if let fontenc = symbol.fontenc {
                    Text("fontenc: {\(fontenc)}")
                        .font(.system(size: 12, design: .monospaced))
                        .foregroundColor(Color.gray)
                }
                
            }
            Spacer()
            Image("\(symbol.css_class)")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width:25, height:25, alignment: .trailing)
                .padding(.top,4)
                .padding(.bottom,4)
                .padding(.leading,4)
                .padding(.trailing, 8)
                .foregroundColor((colorScheme == .light ? Color.black : Color.white))
        }
    }
}


struct SymbolsView_Previews: PreviewProvider {
    static var previews: some View {
        SymbolsView()
            .previewDevice("iPhone 11 Pro Max")
    }
}
