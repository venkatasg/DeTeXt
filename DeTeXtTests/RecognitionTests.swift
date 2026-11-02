//
//  RecognitionTests.swift
//  DeTeXtTests
//
//  End-to-end checks that hand-drawn versions of easily confused symbols still land the
//  right command(s) in the top five results.
//

import Testing
import PencilKit
@testable import DeTeXt

struct AmbiguousSymbol: CustomTestStringConvertible, Sendable {
    let name: String
    /// Every command in this set must appear in the top five. When a glyph has several
    /// equivalent commands (e.g. \Sigma and \sum) all of them are listed.
    let expected: Set<String>
    /// What the drawing is easily mistaken for, documented for whoever reads a failure
    let confusableWith: [String]
    let strokes: [UnitStroke]

    var testDescription: String { name }
}

extension AmbiguousSymbol {
    static let all: [AmbiguousSymbol] = [
        AmbiguousSymbol(name: "alpha", expected: [#"\alpha"#, #"\upalpha"#], confusableWith: [#"\propto"#, #"\infty"#],
                        strokes: [[(0.95, 0.15), (0.75, 0.55), (0.45, 0.85), (0.15, 0.75), (0.1, 0.4), (0.35, 0.2), (0.65, 0.5), (0.95, 0.9)]]),
        AmbiguousSymbol(name: "varepsilon", expected: [#"\varepsilon"#], confusableWith: [#"\Sigma"#, #"\delta"#, #"\in"#],
                        // The middle point is repeated so the B-spline keeps the sharp inward cusp
                        strokes: [[(0.75, 0.15), (0.4, 0.1), (0.25, 0.3), (0.45, 0.48), (0.45, 0.48), (0.45, 0.48), (0.2, 0.6), (0.25, 0.85), (0.75, 0.85)]]),
        AmbiguousSymbol(name: "Sigma / sum", expected: [#"\Sigma"#, #"\sum"#], confusableWith: [#"\zeta"#],
                        strokes: [[(0.85, 0.1), (0.15, 0.1), (0.55, 0.5)], [(0.55, 0.5), (0.15, 0.9), (0.85, 0.9)]]),
        AmbiguousSymbol(name: "Pi / prod", expected: [#"\Pi"#, #"\prod"#], confusableWith: [#"\pi"#, #"\pitchfork"#],
                        strokes: [[(0.1, 0.15), (0.9, 0.15)], [(0.3, 0.15), (0.3, 0.9)], [(0.7, 0.15), (0.7, 0.9)]]),
        AmbiguousSymbol(name: "emptyset", expected: [#"\emptyset"#, #"\varnothing"#], confusableWith: [#"\o"#, #"\phi"#, #"\diameter"#],
                        strokes: [[(0.5, 0.15), (0.2, 0.25), (0.15, 0.55), (0.3, 0.82), (0.6, 0.85), (0.85, 0.6), (0.8, 0.3), (0.5, 0.15)],
                                  [(0.85, 0.05), (0.15, 0.95)]]),
        AmbiguousSymbol(name: "infty", expected: [#"\infty"#], confusableWith: [#"\propto"#, #"\bowtie"#],
                        strokes: [[(0.5, 0.5), (0.3, 0.3), (0.1, 0.4), (0.1, 0.6), (0.3, 0.7), (0.5, 0.5), (0.7, 0.3), (0.9, 0.4), (0.9, 0.6), (0.7, 0.7), (0.5, 0.5)]]),
        AmbiguousSymbol(name: "cup", expected: [#"\cup"#], confusableWith: [#"\upsilon"#, #"\vee"#, "U"],
                        strokes: [[(0.15, 0.1), (0.15, 0.6), (0.3, 0.85), (0.5, 0.9), (0.7, 0.85), (0.85, 0.6), (0.85, 0.1)]]),
        AmbiguousSymbol(name: "times", expected: [#"\times"#, #"\texttimes"#], confusableWith: [#"\chi"#, "x"],
                        strokes: [[(0.2, 0.2), (0.8, 0.8)], [(0.8, 0.2), (0.2, 0.8)]]),
        AmbiguousSymbol(name: "rightarrow", expected: [#"\rightarrow"#], confusableWith: [#"\longrightarrow"#, #"\shortrightarrow"#],
                        strokes: [[(0.05, 0.5), (0.95, 0.5)], [(0.75, 0.35), (0.95, 0.5)], [(0.95, 0.5), (0.75, 0.65)]]),
        AmbiguousSymbol(name: "leq", expected: [#"\leq"#], confusableWith: [#"\subseteq"#, #"\zeta"#],
                        strokes: [[(0.8, 0.1), (0.2, 0.35), (0.8, 0.6)], [(0.2, 0.85), (0.8, 0.85)]]),
        AmbiguousSymbol(name: "neq", expected: [#"\neq"#], confusableWith: [#"\not\equiv"#, #"\ddagger"#],
                        strokes: [[(0.15, 0.38), (0.85, 0.38)], [(0.15, 0.62), (0.85, 0.62)], [(0.65, 0.15), (0.35, 0.85)]]),
        AmbiguousSymbol(name: "partial", expected: [#"\partial"#], confusableWith: [#"\delta"#, "6"],
                        strokes: [[(0.3, 0.2), (0.55, 0.1), (0.75, 0.3), (0.75, 0.65), (0.55, 0.9), (0.3, 0.85), (0.25, 0.65), (0.45, 0.5), (0.7, 0.55)]]),
        AmbiguousSymbol(name: "nabla", expected: [#"\nabla"#], confusableWith: [#"\triangledown"#, #"\bigtriangledown"#],
                        strokes: [[(0.1, 0.15), (0.9, 0.15), (0.5, 0.9), (0.1, 0.15)]]),
        AmbiguousSymbol(name: "int", expected: [#"\int"#], confusableWith: [#"\textesh"#, "f", "S"],
                        strokes: [[(0.75, 0.12), (0.6, 0.05), (0.5, 0.2), (0.5, 0.8), (0.4, 0.95), (0.25, 0.88)]]),
        AmbiguousSymbol(name: "pm", expected: [#"\pm"#, #"\textpm"#], confusableWith: [#"\mp"#],
                        strokes: [[(0.2, 0.4), (0.8, 0.4)], [(0.5, 0.1), (0.5, 0.7)], [(0.2, 0.85), (0.8, 0.85)]]),
        AmbiguousSymbol(name: "omega", expected: [#"\omega"#, #"\textomega"#], confusableWith: [#"\mathcal{W}"#, "w"],
                        strokes: [[(0.15, 0.3), (0.12, 0.7), (0.3, 0.85), (0.5, 0.6), (0.7, 0.85), (0.88, 0.7), (0.85, 0.3)]]),
        AmbiguousSymbol(name: "subset", expected: [#"\subset"#], confusableWith: [#"\mathcal{C}"#, #"\varsigma"#],
                        strokes: [[(0.85, 0.2), (0.4, 0.2), (0.15, 0.5), (0.4, 0.8), (0.85, 0.8)]]),
        AmbiguousSymbol(name: "approx", expected: [#"\approx"#], confusableWith: [#"\thickapprox"#, #"\simeq"#],
                        strokes: [[(0.1, 0.4), (0.3, 0.3), (0.5, 0.4), (0.7, 0.5), (0.9, 0.4)],
                                  [(0.1, 0.65), (0.3, 0.55), (0.5, 0.65), (0.7, 0.75), (0.9, 0.65)]]),
        AmbiguousSymbol(name: "theta", expected: [#"\theta"#], confusableWith: [#"\ominus"#, #"\oplus"#],
                        strokes: [[(0.5, 0.05), (0.25, 0.2), (0.2, 0.5), (0.25, 0.8), (0.5, 0.95), (0.75, 0.8), (0.8, 0.5), (0.75, 0.2), (0.5, 0.05)],
                                  [(0.2, 0.5), (0.8, 0.5)]]),
        AmbiguousSymbol(name: "square root", expected: [#"\sqrt{}"#, #"\surd"#], confusableWith: [#"\checkmark"#],
                        strokes: [[(0.1, 0.55), (0.25, 0.5), (0.4, 0.9), (0.7, 0.1), (0.95, 0.1)]]),
    ]
}

@Suite("Recognition of ambiguous drawings")
struct RecognitionTests {

    @Test("Expected commands appear in the top five", arguments: AmbiguousSymbol.all)
    func topFiveContainsExpected(_ symbol: AmbiguousSymbol) async throws {
        let drawing = SyntheticDrawing.make(symbol.strokes)
        let top = try await Recognizer.shared.topCommands(for: drawing)

        let missing = symbol.expected.subtracting(top)
        #expect(missing.isEmpty, "\(symbol.name): missing \(missing.sorted()) from top 5 \(top) (often confused with \(symbol.confusableWith))")
    }

    @Test("Every expected command is a real symbol", arguments: AmbiguousSymbol.all)
    func expectedCommandsExist(_ symbol: AmbiguousSymbol) {
        let commands = Set(Recognizer.shared.symbols.AllSymbols.map(\.command))
        #expect(symbol.expected.isSubset(of: commands), "\(symbol.expected.subtracting(commands)) not in symbols.json")
    }

    @Test("Where a symbol is drawn on the canvas doesn't change the result")
    func translationInvariance() async throws {
        let strokes = AmbiguousSymbol.all.first { $0.name == "partial" }!.strokes
        let centred = try await Recognizer.shared.rankedLabels(for: SyntheticDrawing.make(strokes))
        let cornered = try await Recognizer.shared.rankedLabels(for: SyntheticDrawing.make(strokes, origin: CGPoint(x: 10, y: 10)))
        #expect(centred.prefix(5) == cornered.prefix(5))
    }

    @Test("Small and large drawings of the same symbol are both recognised", arguments: [80, 280] as [CGFloat])
    func scaleRobustness(size: CGFloat) async throws {
        let symbol = AmbiguousSymbol.all.first { $0.name == "nabla" }!
        let top = try await Recognizer.shared.topCommands(for: SyntheticDrawing.make(symbol.strokes, origin: CGPoint(x: 20, y: 10), size: size))
        #expect(top.contains(#"\nabla"#))
    }
}
