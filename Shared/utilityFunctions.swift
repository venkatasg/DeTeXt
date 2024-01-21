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
        return "DeTeXt \(version)"
    }

// Functions for haptics    
func modelHaptics() {
    #if os(iOS)
    let generator = UINotificationFeedbackGenerator()
    generator.notificationOccurred(.success)
    #endif
}
