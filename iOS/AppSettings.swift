//
//  AppSettings.swift
//  iOS
//
//  Created by Venkat on 20/9/20.
//

import Foundation
import Combine
//import CoreHaptics
import SwiftUI

enum UserInterfaceColorPalette: Int, CustomStringConvertible, CaseIterable {
    case automatic = 0
    case light = 1
    case dark = 2

    var description: String {
        switch self {
        case .automatic:
            return NSLocalizedString("Automatic", comment: "Automatic")
        case .light:
            return NSLocalizedString("Light", comment: "Light")
        case .dark:
            return NSLocalizedString("Dark", comment: "Dark")
        }
    }
}

class AppSettings: ObservableObject {
    
    @Published var userTheme: String {
            didSet {
                UserDefaults.standard.set(userTheme, forKey: "userTheme")
            }
        }
    
//    @Published var supportsHaptics: Bool = false
//        
//    @Published var reduceHaptics: Bool {
//            didSet {
//                UserDefaults.standard.set(reduceHaptics, forKey: "reduceHaptics")
//            }
//        }
//    
//    @Published var pencilClearOnTap: Bool {
//            didSet {
//                UserDefaults.standard.set(pencilClearOnTap, forKey: "pencilClearOnTap")
//            }
//        }
    
    init() {
        // Check if the device supports haptics
//        let hapticCapability = CHHapticEngine.capabilitiesForHardware()
//        self.supportsHaptics = hapticCapability.supportsHaptics

        self.userTheme = UserDefaults.standard.object(forKey: "userTheme") as? String ?? "Automatic"
//        self.reduceHaptics = UserDefaults.standard.object(forKey: "reduceHaptics") as? Bool ?? !hapticCapability.supportsHaptics
//        self.pencilClearOnTap = UserDefaults.standard.object(forKey: "pencilClearOnTap") as? Bool ?? false
    }

}
    
