//
//  TwoColumnMainView.swift
//  iOS - Mac Catalyst
//
//  Created by Venkat on 1/28/21.
//

import SwiftUI

struct TwoColumnMainView: View {
    
    @EnvironmentObject private var symbols: Symbols
    var labelScores: LabelScores
    
    var body: some View {
        HStack {
            CanvasView(labelScores: labelScores)
                .environmentObject(symbols)
            Divider()
            SearchView()
                .environmentObject(symbols)
        }
    }
}

struct TwoColumnMainView_Previews: PreviewProvider {
    
    static let symbols = Symbols()
    static let labelScores = LabelScores()
    
    static var previews: some View {
        Group {
            TwoColumnMainView(labelScores: labelScores)
                .environmentObject(symbols)
        }
    }
}

