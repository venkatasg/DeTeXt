//
//  LoadSymbols.swift
//  DeTeXt
//
//  Created by Venkat on 1/9/20.
//

import Foundation

struct Symbol : Codable, Identifiable {
    let id: String
    let command: String
    let css_class: String
    let mathmode: Bool
    let textmode: Bool
    let package: String?
    let fontenc: String?
}

// ObservableObject must be a class
class Symbols: ObservableObject {
    
    let AllSymbols: [Symbol] = Bundle.main.decode("symbols.json")
    
}

extension Bundle {
    func decode(_ file: String) -> [Symbol] {
        guard let url = self.url(forResource: file, withExtension: nil) else {
            fatalError("Failed to locate \(file) in bundle.")
        }

        guard let data = try? Data(contentsOf: url) else {
            fatalError("Failed to load \(file) from bundle.")
        }

        let decoder = JSONDecoder()

        guard let loaded = try? decoder.decode([Symbol].self, from: data) else {
            fatalError("Failed to decode \(file) from bundle.")
        }

        return loaded
    }
}
