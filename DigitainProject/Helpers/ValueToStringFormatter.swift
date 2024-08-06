//
//  ValueToStringFormatter.swift
//  DigitainProject
//
//  Created by Arshak Manukyan on 05.08.24.
//

import Foundation

struct ValueToStringFormatter {
    
    func formatNumber(_ number: Double, fractionDigits: Int) -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        numberFormatter.groupingSeparator = " "
        numberFormatter.maximumFractionDigits = fractionDigits
        numberFormatter.minimumFractionDigits = fractionDigits
        
        return numberFormatter.string(from: NSNumber(value: number)) ?? ""
    }
    
}
