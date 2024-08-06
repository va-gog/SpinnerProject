//
//  Statistics.swift
//  DigitainProject
//
//  Created by Gohar Vardanyan on 05.08.24.
//

import Foundation

enum StatisticsType: Int, RawRepresentable, Decodable, Equatable {
    case clubs
    case diamonds
    case hearts
    case spades
    
    var icon: String {
        return switch self {
        case .clubs:
            "clubs_ic"
        case .diamonds:
            "diamonds_ic"
        case .hearts:
            "hearts_ic"
        case .spades:
            "spades_ic"
        }
    }
}
