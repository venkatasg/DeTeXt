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
    let showToast: (String) -> Void
    
    var body: some View {
        HStack {
            SymbolDetailsView(symbol: symbol)
                .onTapGesture(count: 2) {
                    pasteboard.string = symbol.command
                    showToast(symbol.command)
                }
            Spacer()
            Image("\(symbol.css_class)", label: Text(symbol.command))
                .font(.hugeTitle)
                .preferredColorScheme(colorScheme)
                .onTapGesture(count: 2) {
                    if let myChar = symbol.unicode {
                        if let num = Int(myChar, radix: 16) {
                            if let scalarValue = UnicodeScalar(num) {
                                let myString = String(scalarValue)
                                pasteboard.string = myString
                                showToast(myString)
                            }
                        }
                    }
                }
        }
        .contentShape(Rectangle())
        .contextMenu{
            // Copy command
            Button {
                pasteboard.string = symbol.command
                showToast(symbol.command)
            } label: {
                Label("Copy command", systemImage: "command.square.fill")
            }
            
            // Copy decoded unicode character
            Button {
                if let myChar = symbol.unicode {
                    if let num = Int(myChar, radix: 16) {
                        if let scalarValue = UnicodeScalar(num) {
                            let myString = String(scalarValue)
                            pasteboard.string = myString
                            showToast(myString)
                    }
                }
                else {
                    pasteboard.string = myChar
                    showToast(myChar)
                    }
                }
                else {
                    showToast("Copy character unavailable.")
                }
            } label : {
                Label("Copy character", systemImage: "character.phonetic")
            }
            .disabled((symbol.unicode ?? "").isEmpty)
            
            // Copy the raw unicode codepoint
            Button {
                if let myChar = symbol.unicode {
                    pasteboard.string = "U+" + myChar
                    showToast("U+" + myChar)
                }
                else {
                    showToast("Copy codepoint unavailable.")
                }
                
            } label : {
                Label("Copy codepoint", systemImage: "number")
            }
            .disabled((symbol.unicode ?? "").isEmpty)
        } preview: {
            SymbolPreviewView(symbol: symbol)
                .frame(minWidth: 300)
        }
    }
}

extension Font {
    static let hugeTitle = Font.custom("San Francisco", size: 40, relativeTo: .largeTitle)
}

extension Image {
    func asThumbnail(colorScheme: ColorScheme) -> some View {
        font(.largeTitle)
            .aspectRatio(contentMode: .fit)
            .frame(width:40, alignment: .center)
            .foregroundColor((colorScheme == .light ? Color.black : Color.white))
    }
}
