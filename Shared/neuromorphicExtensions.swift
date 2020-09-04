//
//  neuromorphicExtensions.swift
//  DeTeXt
//
//  Created by Venkat on 3/9/20.
//
import SwiftUI

extension Color {
    static let neuBackground = Color(hex: "f0f0f3")
    static let dropShadow = Color(hex: "000000").opacity(0.2)
    static let dropLight = Color(hex: "ffffff").opacity(0.7)
    static let neuBackgroundDark = Color(hex: "24292e")
}

extension Color {
    init(hex: String) {
        let scanner = Scanner(string: hex)
        scanner.scanLocation = 0
        var rgbValue: UInt64 = 0
        scanner.scanHexInt64(&rgbValue)

        let r = (rgbValue & 0xff0000) >> 16
        let g = (rgbValue & 0xff00) >> 8
        let b = rgbValue & 0xff

        self.init(red: Double(r) / 0xff, green: Double(g) / 0xff, blue: Double(b) / 0xff)
    }
}
