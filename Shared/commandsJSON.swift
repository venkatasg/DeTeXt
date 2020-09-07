//
//  commandsJSON.swift
//  DeTeXt
//
//  Created by Venkat on 1/9/20.
//

import Foundation

struct Symbol : Decodable {
    var id: String
    var command: String
    var css_class: String
    var mathmode: Bool?
    var textmode: Bool?
    var package: String?
    var fontenc: String?
}

func loadJson() -> [Symbol]? {
    if let url = Bundle.main.url(forResource: "symbols", withExtension: "json") {
        do {
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            let jsonData = try decoder.decode([Symbol].self, from: data)
//            print("done")
            return jsonData
        } catch {
//            print("error:\(error)")
        }
    }
    return nil
}
