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

class AppSettings: ObservableObject {
        
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

//        self.reduceHaptics = UserDefaults.standard.object(forKey: "reduceHaptics") as? Bool ?? !hapticCapability.supportsHaptics
//        self.pencilClearOnTap = UserDefaults.standard.object(forKey: "pencilClearOnTap") as? Bool ?? false
    }

}
    
