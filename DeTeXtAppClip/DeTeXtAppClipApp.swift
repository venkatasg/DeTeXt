//
//  DeTeXtAppClipApp.swift
//  DeTeXtAppClip
//
//  Created by Venkat on 1/10/20.
//

import SwiftUI

@main
struct DeTeXtAppClipApp: App {
    
    @StateObject var symbols = Symbols()
    
    var body: some Scene {
        WindowGroup {
            CanvasView()
                .environmentObject(symbols)
        }
    }
}

struct DeTeXtAppClipApp_Previews: PreviewProvider {
    
    static let symbols = Symbols()
    
    static var previews: some View {
        CanvasView()
            .environmentObject(symbols)
    }
}
