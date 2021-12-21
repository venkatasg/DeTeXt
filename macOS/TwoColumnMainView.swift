//
//  TwoColumnMainView.swift
//  iOS - Mac Catalyst
//
//  Created by Venkat on 1/28/21.
//

import SwiftUI

struct TwoColumnMainView: View {
    
    @ObservedObject var labelScores: LabelScores
    @ObservedObject var symbols: Symbols
    
    var body: some View {
        HStack {
            CanvasView(labelScores: labelScores, symbols: symbols)
            Divider()
            SearchView(symbols: symbols)
        }
    }
}

struct TwoColumnMainView_Previews: PreviewProvider {
    
    static let symbols = Symbols()
    static let labelScores = LabelScores()
    
    static var previews: some View {
        Group {
            TwoColumnMainView(labelScores: labelScores, symbols: symbols)
        }
    }
}

