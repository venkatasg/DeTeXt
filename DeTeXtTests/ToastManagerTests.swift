//
//  ToastManagerTests.swift
//  DeTeXtTests
//

import Testing
@testable import DeTeXt

@MainActor
@Suite("ToastManager")
struct ToastManagerTests {

    @Test("Showing a toast displays its text")
    func showsToast() {
        let manager = ToastManager()
        #expect(manager.currentToast == nil)
        manager.show(#"\alpha"#)
        #expect(manager.currentToast?.text == #"\alpha"#)
    }

    @Test("A new toast replaces the current one")
    func replacesToast() throws {
        let manager = ToastManager()
        manager.show("first")
        let firstID = try #require(manager.currentToast?.id)
        manager.show("second")
        #expect(manager.currentToast?.text == "second")
        #expect(manager.currentToast?.id != firstID)
    }

    @Test("The toast dismisses itself after its duration")
    func dismissesAfterDuration() async throws {
        let manager = ToastManager()
        manager.show("copied", duration: 0.1)
        try await Task.sleep(for: .milliseconds(500))
        #expect(manager.currentToast == nil)
    }

    @Test("Showing a new toast cancels the previous dismissal")
    func newToastResetsTimer() async throws {
        let manager = ToastManager()
        manager.show("first", duration: 0.2)
        manager.show("second", duration: 5)
        try await Task.sleep(for: .milliseconds(500))
        // The first toast's timer must not dismiss the second toast early
        #expect(manager.currentToast?.text == "second")
    }
}
