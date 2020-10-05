//
//  DeTeXtApp.swift
//  DeTeXt Watch Extension
//
//  Created by Venkat on 4/10/20.
//

import SwiftUI

@main
struct DeTeXtApp: App {
    
    @StateObject var symbols = Symbols()
    
    var body: some Scene {
        WindowGroup {
            NavigationView {
                ContentView()
                    .environmentObject(symbols)
            }
        }
    }
}
