//
//  LoadSymbols.swift
//  DeTeXt
//
//  Created by Venkat on 1/9/20.
//

import Foundation

class Symbol : Codable, Identifiable {
    let id: String
    let command: String
    let unicode: String?
    let css_class: String
    let mathmode: Bool
    let textmode: Bool
    let package: String?
}

class Symbols {
    
    let AllSymbols: [Symbol]
    // Index of symbols by id, built once so model labels resolve in constant time
    private let symbolsByID: [String: Symbol]

    init() {
        self.AllSymbols = Bundle.main.decode("symbols.json").sorted { s1,s2 in
            return (s1.package ?? "", s1.command) < (s2.package ?? "", s2.command) }
        self.symbolsByID = Dictionary(AllSymbols.map { ($0.id, $0) }, uniquingKeysWith: { first, _ in first })
    }

    // Returns the symbol for a model class label, or nil if it isn't in symbols.json
    func find(withID id: String) -> Symbol? {
        symbolsByID[id]
    }

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
