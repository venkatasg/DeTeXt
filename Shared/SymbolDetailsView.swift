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
                .padding(.init(top: 2, leading: 0, bottom: 4, trailing: 0))
            
            // Display mode if present
            if (symbol.mathmode && !symbol.textmode) {
                Text("mathmode").def(fontSize: subFontSize)
            }
            
            else if (symbol.textmode && !symbol.mathmode) {
                Text("textmode").def(fontSize: subFontSize)
            }
            
            else if (symbol.textmode && symbol.mathmode) {
                Text("mathmode, textmode").def(fontSize: subFontSize)
            }
            
            else {}

            // Display package if present
            if let package = symbol.package {
                Text("package:\(package)").mono(fontSize: subFontSize)
            }
            
            // Display unicode codepoint if present
            if let unicode = symbol.unicode {
                Text("U+\(unicode)").mono(fontSize: subFontSize)
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
        font(.system(fontSize))
            .foregroundColor(Color.gray)
    }
}
