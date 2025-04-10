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
    
    var body: some Scene {
        #if targetEnvironment(macCatalyst)
        WindowGroup {
            TwoColumnMainView(labelScores: labelScores, symbols: symbols)
        }
        .commands {   
            CommandGroup(replacing: .help, addition: {
                Link("Contact Support...",
                     destination: URL(string: "mailto:venkat@venkatasg.net")!)
                
                Divider()

                Link("Release Notes",
                     destination: URL(string: "https://venkatasg.net/apps/detext#release-notes")!)
                Link("GitHub Repository",
                     destination: URL(string: "https://github.com/venkatasg/DeTeXt")!)
            })
    
            CommandGroup(after: CommandGroupPlacement.undoRedo) {
                Button("Clear Canvas") {
                    self.labelScores.clearScores()
                }
                .keyboardShortcut("r", modifiers: [.command])
            }
        }
        #else
        WindowGroup {
            MainView(labelScores: labelScores, symbols: symbols)
        }
        .defaultSize(CGSize(width: 500, height: 800))
        .commands {
            CommandGroup(after: CommandGroupPlacement.undoRedo) {
                Button("Clear Canvas") {
                    self.labelScores.clearScores()
                }
                .keyboardShortcut("r", modifiers: [.command])
            }
        }
        #endif
    }
}

