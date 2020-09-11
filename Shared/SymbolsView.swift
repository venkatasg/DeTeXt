//
//  SymbolsView.swift
//  DeTeXt
//
//  Created by Venkat on 10/9/20.
//

import SwiftUI

struct SymbolsView: View {
    
    @State var showAboutView = false
//    @ObservedObject var symbols: [Symbol]
    
    var body: some View {
        NavigationView {
            List {
//                ForEach(symbols, id:\.id) { symbol in
//                    Text(symbol.command)
//                }
            }
            .listStyle(InsetListStyle())
            .navigationBarItems(trailing: Button(action: {self.showAboutView.toggle()})
                                            { Text("About").padding(8) })
            .navigationBarTitle("", displayMode: .inline)
        }
        .sheet(isPresented: $showAboutView) { AboutView() }
    }
}



struct SymbolsView_Previews: PreviewProvider {
    static var previews: some View {
        SymbolsView()
            .previewDevice("iPhone 11 Pro Max")
    }
}
