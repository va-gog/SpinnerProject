//
//  SpinnerValueManagerProtocol.swift
//  DigitainProject
//
//  Created by Gohar Vardanyan on 8/5/24.
//

import Foundation
import Combine

protocol SpinnerValueManagerProtocol {
    var spinnerUpdateInfoPublisher: PassthroughSubject<SpinneValueUpdateInfo, Never> { get }

    func updateStatistics(type: StatisticsType)
    func addStatisticsValue(type: StatisticsType, value: Double, repeatCunt: Double)
}
