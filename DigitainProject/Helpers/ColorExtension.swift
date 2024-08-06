//
//  ColorExtension.swift
//  DigitainProject
//
//  Created by Gohar Vardanyan on 8/5/24.
//

import UIKit

extension UIColor {
    convenience init(_ hex: UInt32) {
        let red = Double((hex >> 16) & 0xFF) / 255.0
        let green = Double((hex >> 8) & 0xFF) / 255.0
        let blue = Double(hex & 0xFF) / 255.0
        self.init(red: red, green: green, blue: blue, alpha: 1)
    }
}
