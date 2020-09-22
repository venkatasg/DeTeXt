//
//  utilityFunctions.swift
//  iOS
//
//  Created by Venkat on 21/9/20.
//

import Foundation
import SwiftUI

// Function to find version and build number
func appVersion() -> String {
        let version = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? ""
        let build = Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as? String ?? ""
        return "DeTeXt \(version) (Build \(build))"
    }

func userInterfaceColorScheme(theme: String) -> ColorScheme? {
        switch theme {
        case "Light":
            return ColorScheme.light
        case "Dark":
            return ColorScheme.dark
        default:
            return nil
        }
    }
