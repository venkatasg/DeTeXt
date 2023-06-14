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
                    .asThumbnail(colorScheme: colorScheme)
        }
        .contentShape(Rectangle())
        .onTapGesture(count: 2) {
            pasteboard.string = symbol.command
        }
        .contextMenu(
            ContextMenu(
                menuItems: {
                    Button(action:{ pasteboard.string = symbol.command }){
                        HStack {
                            Text("Copy command")
                            Image(systemName: "doc.on.doc.fill")
                        }
                    }
                }
            )
        )
    }
}

extension Image {
    func asThumbnail(colorScheme: ColorScheme) -> some View {
        font(.largeTitle)
            .aspectRatio(contentMode: .fit)
            .frame(width:40, alignment: .center)
            .foregroundColor((colorScheme == .light ? Color.black : Color.white))
    }
}
