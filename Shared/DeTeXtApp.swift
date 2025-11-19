//
//  DeTeXtApp.swift
//  Shared
//
//  Created by Venkat on 29/8/20.
//

import SwiftUI
import PencilKit

@Observable @MainActor
class LabelScores {
    var scores = [Dictionary<String, Double>.Element]()
    
    func clearScores() {
        self.scores = [Dictionary<String, Double>.Element]()
    }
    
    func updateScores(updatedScores : [String : Double]) {
        self.scores = Array(updatedScores.sorted { $0.1 > $1.1 } [..<20])
    }
}

@main
struct DeTeXtApp: App {
    
    @State var labelScores: LabelScores = LabelScores()
    let symbols = Symbols()
    @State var selectedTabIndex = 0
    @State var presentSearch = false
    
    var body: some Scene {
        WindowGroup {
            MainView(
                selectedTabIndex: $selectedTabIndex,
                presentSearch: $presentSearch,
                labelScores: labelScores,
                symbols: symbols
            )
        }
        .defaultSize(CGSize(width: 500, height: 750))
        .windowResizability(.contentSize)
        .commands {
            CommandGroup(replacing: .help, addition: {
                Link(destination: URL(string: "https://venkatasg.net/apps/detext#support")!) {
                    Label("Contact Support", systemImage: "envelope")
                }
                
                Divider()

                Link(destination: URL(string: "https://venkatasg.net/apps/detext#release-notes")!) {
                    Label("Release Notes", systemImage: "list.bullet.clipboard")
                }
                Link(destination: URL(string: "https://github.com/venkatasg/DeTeXt")!) {
                    Label("GitHub Repository",systemImage: "cloud")
                }
            })
    
            CommandGroup(after: CommandGroupPlacement.undoRedo) {
                Button("Clear Canvas") {
                    self.labelScores.clearScores()
                }
                .keyboardShortcut("r", modifiers: [.command])
                
                Button("Find Symbol") {
                    self.selectedTabIndex = 1
                    self.presentSearch = true
                }
                .keyboardShortcut("f", modifiers: [.command])
            }
        }
    }
}
