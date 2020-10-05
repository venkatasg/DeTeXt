//
//  ContentView.swift
//  DeTeXt Watch Extension
//
//  Created by Venkat on 4/10/20.
//

import SwiftUI

struct ContentView: View {
    
    @EnvironmentObject var symbols: Symbols
    
    var body: some View {
            List(symbols.AllSymbols) { symbol in
                HStack {
                    SymbolDetailsView(symbol: symbol)
                    Spacer()
                    ZStack {
                        Image("\(symbol.css_class)", label: Text(symbol.command))
                            .font(.largeTitle)
                            .aspectRatio(contentMode: .fit)
                            .frame(width:40, alignment: .center)
                            .foregroundColor(Color.white)
                    }
                    .frame(width:40, height:40, alignment: .trailing)
                    
                }
            }
            .listStyle(CarouselListStyle())
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(Symbols())
    }
}
