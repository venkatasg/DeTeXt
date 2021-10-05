//
//  DeTeXtApp.swift
//  Shared
//
//  Created by Venkat on 29/8/20.
//

import SwiftUI
import PencilKit

class LabelScores: ObservableObject {
    @Published var scores = [Dictionary<String, Double>.Element]()
    
    func ClearScores() {
        self.scores = [Dictionary<String, Double>.Element]()
    }
}

@main
struct DeTeXtApp: App {
    
    @StateObject var symbols = Symbols()
    @StateObject var labelScores: LabelScores = LabelScores()

    var body: some Scene {
        #if targetEnvironment(macCatalyst)
        WindowGroup {
            SidebarView(labelScores: labelScores, symbols: symbols)
        }
        .commands {   
            CommandGroup(replacing: .help, addition: {
                Link("Send me an email",
                     destination: URL(string: "mailto:venkat@venkatasg.net")!)
                
                Divider()
                
                Link("Website",
                     destination: URL(string: "https://venkatasg.net/apps/detext")!)
                Link("Release Notes",
                     destination: URL(string: "https://venkatasg.net/apps/detext#release-notes")!)
                Link("GitHub Repository",
                     destination: URL(string: "https://github.com/venkatasg/DeTeXt")!)
            })
    
            CommandGroup(after: CommandGroupPlacement.undoRedo) {
                Button("Clear Canvas") {
                    self.labelScores.ClearScores()
                }
                .keyboardShortcut("r", modifiers: [.command])
            }
        }
        #else
        WindowGroup {
            MainView(labelScores: labelScores, symbols: symbols)
        }
        .commands {
            CommandGroup(after: CommandGroupPlacement.undoRedo) {
                Button("Clear Canvas") {
                    self.labelScores.ClearScores()
                }
                .keyboardShortcut("r", modifiers: [.command])
            }
        }
        #endif
    }
}



