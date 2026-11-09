//
//  LabelScoresTests.swift
//  DeTeXtTests
//

import Testing
@testable import DeTeXt

@MainActor
@Suite("LabelScores")
struct LabelScoresTests {

    @Test("Starts empty")
    func startsEmpty() {
        #expect(LabelScores().scores.isEmpty)
    }

    @Test("Keeps the 20 highest scores in descending order")
    func keepsTopTwentySorted() {
        let labelScores = LabelScores()
        let input = Dictionary(uniqueKeysWithValues: (0..<50).map { ("label\($0)", Double($0) / 50) })

        labelScores.updateScores(updatedScores: input)

        #expect(labelScores.scores.count == 20)
        #expect(labelScores.scores.first?.key == "label49")
        #expect(labelScores.scores.last?.key == "label30")
        #expect(zip(labelScores.scores, labelScores.scores.dropFirst()).allSatisfy { $0.value >= $1.value })
    }

    @Test("Handles fewer than 20 scores")
    func fewerThanTwenty() {
        let labelScores = LabelScores()
        labelScores.updateScores(updatedScores: ["a": 0.1, "b": 0.7, "c": 0.2])
        #expect(labelScores.scores.map(\.key) == ["b", "c", "a"])
    }

    @Test("New scores replace old ones")
    func replacesScores() {
        let labelScores = LabelScores()
        labelScores.updateScores(updatedScores: ["a": 0.9])
        labelScores.updateScores(updatedScores: ["b": 0.4])
        #expect(labelScores.scores.map(\.key) == ["b"])
    }

    @Test("Clearing removes all scores")
    func clears() {
        let labelScores = LabelScores()
        labelScores.updateScores(updatedScores: ["a": 0.9, "b": 0.1])
        labelScores.clearScores()
        #expect(labelScores.scores.isEmpty)
    }
}
