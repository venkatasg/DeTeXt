//
//  ContentView.swift
//  DeTeXt Watch Extension
//
//  Created by Venkat on 4/10/20.
//

import SwiftUI

struct ContentView: View {
    
    @EnvironmentObject var symbols: Symbols
    @State var pack: String
    
    var body: some View {
        NavigationView {
            List(symbols.AllSymbols.filter({ $0.package?.lowercased().contains(pack) ?? false})) { symbol in
                HStack {
                    ZStack {
                        Image("\(symbol.css_class)", label: Text(symbol.command))
                            .font(.largeTitle)
                            .aspectRatio(contentMode: .fit)
                            .frame(height:40, alignment: .center)
                            .foregroundColor(Color.white)
                    }
                    .frame(height:40, alignment: .leading)
                    .padding(.trailing, 10)
                    SymbolDetailsView(symbol: symbol)
                }
            }
            .listStyle(CarouselListStyle())
            .navigationBarTitle(pack)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(pack: "tipa")
            .environmentObject(Symbols())
    }
}
