//
//  utilityFunctions.swift
//  iOS
//
//  Created by Venkat on 21/9/20.
//

import Foundation
import UIKit

// Function to find version and build number
func appVersion() -> String {
        let version = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? ""
        let build = Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as? String ?? ""
        return "DeTeXt \(version) (Build \(build))"
    }

// Functions for haptics
func modelHaptics() {
    let generator = UINotificationFeedbackGenerator()
    generator.notificationOccurred(.success)
}
