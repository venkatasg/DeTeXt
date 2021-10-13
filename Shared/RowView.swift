//
//  RowView.swift
//  iOS
//
//  Created by Venkat on 1/10/20.
//

import SwiftUI

struct RowView: View {
    
    @Environment(\.colorScheme) var colorScheme
    
    #if targetEnvironment(macCatalyst)
        let confidenceFontSize = Font.TextStyle.title2
    #else
        let confidenceFontSize = Font.TextStyle.callout
    #endif
    
    let symbol: Symbol
    var confidence: Double?
    
    var body: some View {
        Group {
            if let conf = confidence {
                HStack {
                    Image("\(symbol.css_class)", label: Text(symbol.command))
                            .asThumbnail(colorScheme: colorScheme)
                    
                    Divider()
                    
                    SymbolDetailsView(symbol: symbol)
                    
                    Spacer()
                    
                    Text(String(format: "%.1f", conf) + "%")
                        .font(.system(confidenceFontSize, design: .rounded))
                }
            }
            else {
                HStack {
                    SymbolDetailsView(symbol: symbol)
                    
                    Spacer()
                    
                    Image("\(symbol.css_class)", label: Text(symbol.command))
                            .asThumbnail(colorScheme: colorScheme)
                    
                }
            }
        }
        .contextMenu(ContextMenu(menuItems: {
            Button(action: {
                let pasteboard = UIPasteboard.general
                pasteboard.string = symbol.command
            }){
                HStack {
                    Text("Copy command")
                    Image(systemName: "doc.on.doc.fill")
                }
            }
        }))
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
