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
    let toastManager: ToastManager
    
    var body: some View {
        HStack {
            SymbolDetailsView(symbol: symbol)
                .onTapGesture(count: 2) {
                    pasteboard.string = symbol.command
                    toastManager.show(symbol.command)
                    modelHaptics()
                }
            Spacer()
            Image("\(symbol.css_class)", label: Text(symbol.command))
                .font(.hugeTitle)
                .preferredColorScheme(colorScheme)
                .onTapGesture(count: 2) {
                    copyCharacter(toast: true)
                }
        }
        .contentShape(Rectangle())
        .contextMenu{
            // Copy command string
            Button {
                pasteboard.string = symbol.command
            } label: {
                Label("Copy command", systemImage: "command.square.fill")
            }
            
            // Copy decoded unicode character
            Button {
                copyCharacter()
            } label : {
                Label("Copy character", systemImage: "character.phonetic")
            }
            .disabled((symbol.unicode ?? "").isEmpty)
            
            // Copy the raw unicode codepoint
            Button {
                if let myChar = symbol.unicode {
                    pasteboard.string = "U+" + myChar
                    modelHaptics()
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
    
    private func copyCharacter(toast: Bool = false) {
        if let myChar = symbol.unicode {
            // Unicode needs to be encoded decoded here
            if let num = Int(myChar, radix: 16) {
                if let scalarValue = UnicodeScalar(num) {
                    let myString = String(scalarValue)
                    pasteboard.string = myString
                    if toast {
                        toastManager.show(myString)
                    }
                    modelHaptics()
                }
            }
        }
        // Fail gracefully
//        else {
//            if toast {
//                toastManager.show("Copy unavailable.")
//            }
//            modelHaptics()
//        }
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
