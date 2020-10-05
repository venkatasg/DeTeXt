//
//  SymbolDetailsView.swift
//  iOS
//
//  Created by Venkat on 4/10/20.
//

import SwiftUI

struct SymbolDetailsView: View {
    let symbol: Symbol
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("\(symbol.command)")
                .font(.system(.headline, design: .monospaced))
                .padding(.bottom, 4)
                .padding(.top, 4)
            #if !os(watchOS)
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
            #endif
            
        }
    }
}
