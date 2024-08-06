//
//  GameStatistics.swift
//  DigitainProject
//
//  Created by Gohar Vardanyan on 8/2/24.
//

import Foundation

struct Statistics: Decodable {
    var items = [StatisticsItem]()
    var currency: String
    var digitsAfterPoint: Int
    
    enum CodingKeys: String, CodingKey {
        case clubs
        case diamonds
        case hearts
        case spades
        case digitsAfterPoint
        case currency
    }
    
    enum CurrentKeys: String, CodingKey {
        case current
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let clubsContainer = try container.nestedContainer(keyedBy: CurrentKeys.self, forKey: .clubs)
        let clubsCurrent = try clubsContainer.decode(Double.self, forKey: .current)
        items.append(StatisticsItem(current: clubsCurrent, type: .clubs))
        
        let diamondsContainer = try container.nestedContainer(keyedBy: CurrentKeys.self, forKey: .diamonds)
        let diamondsCurrent = try diamondsContainer.decode(Double.self, forKey: .current)
        items.append(StatisticsItem(current: diamondsCurrent, type: .diamonds))
        
        let heartsContainer = try container.nestedContainer(keyedBy: CurrentKeys.self, forKey: .hearts)
        let heartsCurrent = try heartsContainer.decode(Double.self, forKey: .current)
        items.append(StatisticsItem(current: heartsCurrent, type: .hearts))
        
        let spadesContainer = try container.nestedContainer(keyedBy: CurrentKeys.self, forKey: .spades)
        let spadesCurrent = try spadesContainer.decode(Double.self, forKey: .current)
        items.append(StatisticsItem(current: spadesCurrent, type: .spades))
        
        digitsAfterPoint = try container.decode(Int.self, forKey: .digitsAfterPoint)
        currency = try container.decode(String.self, forKey: .currency)
    }
    
}

