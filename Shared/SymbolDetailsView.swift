//
//  SymbolDetailsView.swift
//  iOS
//
//  Created by Venkat on 4/10/20.
//

import SwiftUI

struct SymbolDetailsView: View {
    let symbol: Symbol
    #if targetEnvironment(macCatalyst)
        let mainFontSize = Font.TextStyle.title
        let subFontSize = Font.TextStyle.body
    #else
        let mainFontSize = Font.TextStyle.headline
        let subFontSize = Font.TextStyle.footnote
    #endif
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("\(symbol.command)")
                .font(.system(mainFontSize, design: .monospaced))
                .padding(.bottom, 4)
                .padding(.top, 4)
            
            if symbol.mathmode {
                Text(" mathmode")
                    .font(.system(subFontSize, design: .default))
                    .foregroundColor(Color.gray)
            }
            else if symbol.textmode {
                Text(" textmode")
                    .font(.system(subFontSize, design: .default))
                    .foregroundColor(Color.gray)
            }
            else {}

            if let package = symbol.package {
                Text("\\usepackage{\(package)}")
                    .font(.system(subFontSize, design: .monospaced))
                    .foregroundColor(Color.gray)
            }
            
            
            if let fontenc = symbol.fontenc {
                Text("fontenc: \(fontenc)")
                    .font(.system(subFontSize, design: .monospaced))
                    .foregroundColor(Color.gray)
            }
        }
    }
}
