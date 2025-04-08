//
//  TwoColumnMainView.swift
//  iOS - Mac Catalyst
//
//  Created by Venkat on 1/28/21.
//

import SwiftUI

struct TwoColumnMainView: View {
    
    var labelScores: LabelScores
    let symbols: Symbols
    
    var body: some View {
        HStack {
            CanvasView(labelScores: labelScores, symbols: symbols)
            Divider()
            SearchView(symbols: symbols)
        }
    }
}

struct TwoColumnMainView_Previews: PreviewProvider {
    
    static let labelScores = LabelScores()
    static let symbols = Symbols()
    static var previews: some View {
        Group {
            TwoColumnMainView(labelScores: labelScores, symbols: symbols)
        }
    }
}

