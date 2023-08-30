//
//  RowView.swift
//  iOS
//
//  Created by Venkat on 1/10/20.
//

import SwiftUI

struct RowView: View {
    
    @Environment(\.colorScheme) var colorScheme
    
    let symbol: Symbol
    let pasteboard = UIPasteboard.general
    
    var body: some View {
        HStack {
            SymbolDetailsView(symbol: symbol)
            Spacer()
            Image("\(symbol.css_class)", label: Text(symbol.command))
                .font(.hugeTitle)
                .preferredColorScheme(colorScheme)
        }
        .contentShape(Rectangle())
        .onTapGesture(count: 2) {
            pasteboard.string = symbol.command
        }
        .contextMenu{
            // Copy command
            Button {
                pasteboard.string = symbol.command
            } label: {
                Label("Copy command", systemImage: "command")
            }
            
            // Copy decoded unicode character
            Button {
                if let num = Int(symbol.unicode!, radix: 16) {
                    if let scalarValue = UnicodeScalar(num) {
                        let myString = String(scalarValue)
                        pasteboard.string = myString
                    }
                }
                else {
                    pasteboard.string = symbol.unicode!
                }
            } label : {
                Label("Copy character", systemImage: "sum")
            }
            .disabled((symbol.unicode ?? "").isEmpty)
            
            // Copy the raw unicode codepoint
            Button {
                pasteboard.string = "U+" + symbol.unicode!
            } label : {
                Label("Copy code point", systemImage: "number")
            }
            .disabled((symbol.unicode ?? "").isEmpty)
        } preview: {
            SymbolPreviewView(symbol: symbol)
                .frame(minWidth: 300)
        }
    }
}

extension Font {
    static let hugeTitle = Font.custom(".system", size: 40, relativeTo: .largeTitle)
}

extension Image {
    func asThumbnail(colorScheme: ColorScheme) -> some View {
        font(.largeTitle)
            .aspectRatio(contentMode: .fit)
            .frame(width:40, alignment: .center)
            .foregroundColor((colorScheme == .light ? Color.black : Color.white))
    }
}
