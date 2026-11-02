//
//  SymbolsTests.swift
//  DeTeXtTests
//

import Testing
import CoreML
import UIKit
@testable import DeTeXt

@Suite("Symbol catalogue")
struct SymbolsTests {
    let symbols = Recognizer.shared.symbols

    @Test("symbols.json loads every symbol")
    func loadsAllSymbols() {
        #expect(symbols.AllSymbols.count == 1098)
    }

    @Test("Symbol IDs are unique")
    func idsAreUnique() {
        let ids = symbols.AllSymbols.map(\.id)
        #expect(Set(ids).count == ids.count)
    }

    @Test("Symbols are sorted by package, then command")
    func sortedByPackageThenCommand() {
        let keys = symbols.AllSymbols.map { ($0.package ?? "", $0.command) }
        #expect(zip(keys, keys.dropFirst()).allSatisfy { $0 <= $1 })
    }

    @Test("find(withID:) returns the matching symbol")
    func findByID() throws {
        let sum = try #require(symbols.find(withID: "latex2e-OT1-_sum"))
        #expect(sum.command == #"\sum"#)
        #expect(sum.mathmode)

        let leq = try #require(symbols.find(withID: "amssymb-OT1-_leq"))
        #expect(leq.package == "amssymb")
    }

    @Test("find(withID:) returns nil for unknown IDs")
    func findUnknownID() {
        #expect(symbols.find(withID: "not-a-symbol") == nil)
        #expect(symbols.find(withID: "") == nil)
    }

    @Test("Every model class label maps to a symbol")
    func everyModelLabelResolves() throws {
        // CanvasView silently drops results it can't find, so a mismatch would hide predictions
        let labels = try #require(Recognizer.shared.model.model.modelDescription.classLabels as? [String])
        #expect(!labels.isEmpty)
        let unresolved = labels.filter { symbols.find(withID: $0) == nil }
        #expect(unresolved.isEmpty, "Labels without a symbol: \(unresolved.prefix(10))")
    }

    @Test("Every symbol is something the model can predict")
    func everySymbolIsAModelLabel() throws {
        let labels = Set(try #require(Recognizer.shared.model.model.modelDescription.classLabels as? [String]))
        let unreachable = symbols.AllSymbols.map(\.id).filter { !labels.contains($0) }
        #expect(unreachable.isEmpty, "Symbols the model never predicts: \(unreachable.prefix(10))")
    }

    @Test("Unicode code points decode to a character")
    func unicodeCodePointsAreValid() {
        // RowView's "Copy character" turns these hex strings into a UnicodeScalar
        let invalid = symbols.AllSymbols.filter { symbol in
            guard let hex = symbol.unicode else { return false }
            return Int(hex, radix: 16).flatMap(UnicodeScalar.init) == nil
        }
        #expect(invalid.isEmpty, "Invalid code points: \(invalid.map(\.command))")
    }

    @Test("Every symbol has a command, image and mode")
    func requiredFieldsPresent() {
        for symbol in symbols.AllSymbols {
            #expect(!symbol.command.isEmpty, "\(symbol.id) has no command")
            #expect(!symbol.css_class.isEmpty, "\(symbol.id) has no image")
            #expect(symbol.mathmode || symbol.textmode, "\(symbol.id) is neither math nor text mode")
        }
    }

    @Test("Every symbol has an image in the asset catalogue")
    func imagesExist() {
        let missing = symbols.AllSymbols.filter { UIImage(named: $0.css_class) == nil }
        #expect(missing.isEmpty, "Missing images: \(missing.prefix(10).map(\.command))")
    }
}
