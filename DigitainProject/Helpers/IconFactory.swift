//
//  IconFactory.swift
//  DigitainProject
//
//  Created by Gohar Vardanyan on 8/5/24.
//

import UIKit

struct IconFactory {
    func currencyIcon(_ currency: String) -> UIImage? {
        var icon: String = ""
        switch currency {
        case "USD", "BYN":
            icon = "dollarsign"
        case "EUR":
            icon = "eurosign"
        default:
            icon = ""
        }
        return UIImage(systemName: icon)
    }
}
