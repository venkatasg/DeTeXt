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
            
            // Display mode if present
            if symbol.mathmode {
                Text(" mathmode").def(fontSize: subFontSize)
            }
            else if symbol.textmode {
                Text(" textmode").def(fontSize: subFontSize)
            }
            else {}

            // Display package if present
            if let package = symbol.package {
                Text("\\usepackage{\(package)}").mono(fontSize: subFontSize)
            }
            
            // Display font enc if present
            if let fontenc = symbol.fontenc {
                Text("fontenc: \(fontenc)").mono(fontSize: subFontSize)
            }
        }
    }
}

extension Text {
    // Text View modifier to show monospace text for package name and fontenc
    func mono(fontSize: Font.TextStyle) -> some View {
        font(.system(fontSize, design: .monospaced))
            .foregroundColor(Color.gray)
    }
    
    // Text view modifier to show text for mode
    func def(fontSize: Font.TextStyle) -> some View {
        font(.system(fontSize, design: .default))
            .foregroundColor(Color.gray)
    }
}
