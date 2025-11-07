//
//  MainView.swift
//  iOS
//
//  Created by Venkat on 3/10/20.
//

import SwiftUI
import UIKit

struct MainView: View {
    
    var labelScores: LabelScores
    let symbols: Symbols
    
    // variables for search functionality
    @State private var searchText = ""
    
        
    var body: some View {
        NavigationStack {
            CanvasView(symbols: symbols, labelScores: labelScores, searchText: $searchText)
                .searchable(
                    text: $searchText,
                    placement: .toolbar,
                    prompt: "Search by command or package"
                )
        }
    }
}

struct MainView_Previews: PreviewProvider {
    
    static let labelScores = LabelScores()
    static let symbols = Symbols()
    static var previews: some View {
        Group {
            MainView(labelScores: labelScores, symbols: symbols)
        }
    }
}
