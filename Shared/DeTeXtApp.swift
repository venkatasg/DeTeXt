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
        #if targetEnvironment(macCatalyst)
        WindowGroup {
            SidebarView()
                .environmentObject(symbols)
        }
        .commands {   
            CommandGroup(replacing: .help, addition: {
                Link("Help and Support",
                     destination: URL(string: "https://venkatasg.me/apps/detext#support")!)
                
                Divider()
                
                Link("Website",
                     destination: URL(string: "https://venkatasg.me/apps/detext")!)
                Link("GitHub Repository",
                     destination: URL(string: "https://github.com/venkatasg/DeTeXt")!)
                
                Divider()
                
                Link("Credits",
                     destination: URL(string: "https://venkatasg.me/apps/detext#credits")!)
                Link("Version History",
                     destination: URL(string: "https://venkatasg.me/apps/detext#version-history")!)
            })
    
            CommandGroup(after: CommandGroupPlacement.undoRedo) {
                Button("Clear Canvas") {
                    print("Clear canvas")
                }
                .keyboardShortcut("r", modifiers: [.command])
            }
        }
        #else
        WindowGroup {
            MainView()
                .environmentObject(symbols)
        }
        #endif
    }
}



