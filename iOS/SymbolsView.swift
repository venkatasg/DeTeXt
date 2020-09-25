//
//  SymbolsView.swift
//  DeTeXt
//
//  Created by Venkat on 10/9/20.
//

import SwiftUI

struct SymbolsView: View {
    
    @State var searchText = ""
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var symbols: Symbols
        
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                SearchBar(text: $searchText)
                    .padding(.top, 8)
                    .padding(.bottom, 8)
                Divider()
                List(symbols.AllSymbols.filter({searchText.isEmpty ? true : ($0.command.lowercased().contains(searchText.lowercased()))})) { symbol in
                    RowView(symbol: symbol)
                }
                .listStyle(InsetListStyle())
            }
            .navigationBarTitle("Search", displayMode: .inline)
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

struct SearchBar: View {
    
    @Binding var text: String
    @State private var isEditing = false
 
    var body: some View {
        HStack {
            TextField("Search", text: $text)
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

struct RowView: View {
    
    let symbol: Symbol
    @Environment(\.colorScheme) var colorScheme
    var confidence: Double?
    
    var body: some View {
        if let conf = confidence {
            HStack {
                ZStack {
                    Image("\(symbol.css_class)")
                        .font(.largeTitle)
                        .aspectRatio(contentMode: .fit)
                        .frame(width:40, alignment: .center)
                        .foregroundColor((colorScheme == .light ? Color.black : Color.white))
                }
                .frame(width:40, height:40, alignment: .leading)
                Divider()
                SymbolDetailsView(symbol: symbol)
                    .padding(.leading, 4)
                Spacer()
                Text(String(format: "%.1f", conf) + "%")
                    .font(.system(.callout, design: .rounded))
            }
        }
        
        else {
            HStack {
                SymbolDetailsView(symbol: symbol)
                Spacer()
                ZStack {
                    Image("\(symbol.css_class)")
                        .font(.largeTitle)
                        .aspectRatio(contentMode: .fit)
                        .frame(width:40, alignment: .center)
                        .foregroundColor((colorScheme == .light ? Color.black : Color.white))
                }
                .frame(width:40, height:40, alignment: .trailing)
                
            }
        }
    }
}

struct SymbolDetailsView: View {
    let symbol: Symbol
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("\(symbol.command)")
                .font(.system(.headline, design: .monospaced))
                .padding(.bottom, 4)
                .padding(.top, 4)
            if symbol.mathmode {
                Text(" mathmode")
                    .font(.footnote)
                    .foregroundColor(Color.gray)
            }
            else if symbol.textmode {
                Text(" textmode")
                    .font(.footnote)
                    .foregroundColor(Color.gray)
            }
            else {}

            if let package = symbol.package {
                Text("\\usepackage{\(package)}")
                    .font(.system(.footnote, design: .monospaced))
                    .foregroundColor(Color.gray)
            }
            
            
            if let fontenc = symbol.fontenc {
                Text("fontenc: \(fontenc)")
                    .font(.system(.footnote, design: .monospaced))
                    .foregroundColor(Color.gray)
            }
            
        }
    }
}

struct SymbolsView_Previews: PreviewProvider {
    static let symbols = Symbols()
    static var previews: some View {
        Group {
            SymbolsView()
                .environmentObject(symbols)
                .previewDevice("iPhone 11 Pro Max")
        }
    }
}
