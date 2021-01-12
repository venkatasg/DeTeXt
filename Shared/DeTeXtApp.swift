//
//  DeTeXtApp.swift
//  Shared
//
//  Created by Venkat on 29/8/20.
//

import SwiftUI

@main
struct DeTeXtApp: App {
    
    @StateObject var symbols = Symbols()

    var body: some Scene {
        WindowGroup {
            MainView()
                .environmentObject(symbols)
        }
    }
}



