//
//  TestSupport.swift
//  DeTeXtTests
//
//  Helpers for synthesising handwritten drawings and running them through the same
//  preprocessing and Core ML pipeline the canvas uses.
//

import CoreML
import Testing
import PencilKit
@testable import DeTeXt

/// A stroke described in a unit square (0...1 on both axes, y pointing down). The points are
/// smoothed with PencilKit's B-spline interpolation so curves look like a finger or pencil drew them.
typealias UnitStroke = [(CGFloat, CGFloat)]

enum SyntheticDrawing {
    /// Size of the canvas on an iPhone in portrait (it has a 1.5 aspect ratio)
    static let canvasSize = CGSize(width: 450, height: 300)

    /// Builds a PKDrawing the way PKCanvasView would record it: black pen strokes densely sampled
    /// with increasing time offsets, positioned at `origin` and scaled to `size` points
    static func make(_ strokes: [UnitStroke], origin: CGPoint = CGPoint(x: 135, y: 60), size: CGFloat = 180,
                     samplesPerSegment: Int = 12) -> PKDrawing {
        PKDrawing(strokes: strokes.map { stroke in
            // Treat the unit points as the B-spline control points of a sparse path, then sample
            // PencilKit's own interpolation of that path to get a dense, smooth stroke
            let sparse = PKStrokePath(controlPoints: stroke.enumerated().map { index, point in
                PKStrokePoint(location: CGPoint(x: origin.x + point.0 * size, y: origin.y + point.1 * size),
                              timeOffset: Double(index * samplesPerSegment) * 0.01, size: CGSize(width: 15, height: 15),
                              opacity: 1, force: 1, azimuth: 0, altitude: .pi / 2)
            }, creationDate: Date())

            let steps = (sparse.count - 1) * samplesPerSegment
            let dense = (0...steps).map { sparse.interpolatedPoint(at: CGFloat($0) / CGFloat(samplesPerSegment)) }
            return PKStroke(ink: PKInk(.pen, color: .black), path: PKStrokePath(controlPoints: dense, creationDate: Date()))
        })
    }
}

/// Runs drawings through the app's recognition pipeline and returns ranked LaTeX commands
final class Recognizer {
    static let shared = Recognizer()

    let model: deTeX
    let symbols = Symbols()

    /// Matches `trainedImageSize` in PKCanvas.Coordinator
    static let inputSize = CGSize(width: 300, height: 200)

    private init() {
        model = try! deTeX(configuration: MLModelConfiguration())
    }

    /// Model class labels ordered by descending probability
    func rankedLabels(for drawing: PKDrawing, canvasSize: CGSize = SyntheticDrawing.canvasSize) async throws -> [String] {
        let processed = drawing.normalizedForModel(canvasSize: canvasSize)
        let buffer = try #require(await processed.modelInput(size: Self.inputSize))
        let output = try model.prediction(drawing: buffer)
        return output.classLabelProbs.sorted { $0.value > $1.value }.map(\.key)
    }

    /// The commands of the `count` most likely symbols
    func topCommands(for drawing: PKDrawing, count: Int = 5, canvasSize: CGSize = SyntheticDrawing.canvasSize) async throws -> [String] {
        try await rankedLabels(for: drawing, canvasSize: canvasSize)
            .prefix(count)
            .map { symbols.find(withID: $0)?.command ?? $0 }
    }
}
