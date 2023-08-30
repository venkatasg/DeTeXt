//
//  SymbolPreviewView.swift
//  iOS
//
//  Created by Venkat on 27/8/23.
//

import SwiftUI

struct SymbolPreviewView: View {
    
    @Environment(\.colorScheme) var colorScheme
    let symbol: Symbol
    
    var body: some View {
        VStack  {
            Image("\(symbol.css_class)", label: Text(symbol.command))
                .font(.system(size: 200))
                .preferredColorScheme(colorScheme)
                .padding(.init(top: 10, leading: 0, bottom: 5, trailing: 0))
            
            Divider()
            
            Text("\(symbol.command)")
                .font(.system(.title, design: .monospaced, weight: .semibold))
                .padding(.init(top: 5, leading: 10, bottom: 0, trailing: 10))
            
            // Display mode if present
            // ZStack{
            if (symbol.mathmode && !symbol.textmode) {
                Text("mathmode")
            }
            else if (symbol.textmode && !symbol.mathmode) {
                Text("textmode")
            }
            else if (symbol.textmode && symbol.mathmode) {
                Text("mathmode, textmode")
            }
            else {}
            // }
            // .padding(.init(top: 0, leading: 10, bottom: 0, trailing: 10))
            
            // Display package if present
            if let package = symbol.package {
                Text("package:\(package)")
                    .font(.system(.body, design: .monospaced))
                    .padding(.init(top: 0, leading: 10, bottom: 0, trailing: 10))
            }
            
            // Display unicode codepoint if present
            if let unicode = symbol.unicode {
                Text("U+\(unicode)")
                    .font(.system(.body, design: .monospaced))
                    .padding(.init(top: 0, leading: 10, bottom: 0, trailing: 10))
            }
            Spacer()
        }
    }
}
