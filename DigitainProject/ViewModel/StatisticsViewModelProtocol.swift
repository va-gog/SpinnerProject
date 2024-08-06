//
//  StatisticsViewModelProtocol.swift
//  DigitainProject
//
//  Created by Gohar Vardanyan on 8/5/24.
//

import Foundation
import Combine

protocol StatisticsViewModelProtocol {
    var spinnerItemsCount: Int { get }
    var spinnerItemValues: [StatisticsItemPresentationModel] { get }
    var spinnerUpdateInfoPublisher: PassthroughSubject<SpinneValueUpdateInfo?, Never> { get }

    func startSpinning() async
    func scrollToStatistics(type: StatisticsType?)
}
