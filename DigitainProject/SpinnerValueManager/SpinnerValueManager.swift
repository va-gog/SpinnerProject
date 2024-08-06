//
//  SpinnerValueManager.swift
//  DigitainProject
//
//  Created by Gohar Vardanyan on 8/3/24.
//

import Foundation
import Combine

final class SpinnerValueManager: SpinnerValueManagerProtocol {
    var spinnerUpdateInfoPublisher = PassthroughSubject<SpinneValueUpdateInfo, Never>()

    private var queue = DispatchQueue(label: "Spinner queue", attributes: .concurrent)
    private var spinnerValues = [StatisticsType: [Double]]()
    
    init(spinnerValues: [StatisticsType : [Double]] = [StatisticsType: [Double]]()) {
        self.spinnerValues = spinnerValues
    }
    
    func updateStatistics(type: StatisticsType) {
        queue.async(flags: .barrier, execute: { [weak self] in
            guard let self else { return }
            let statistics = self.spinnerValues.first(where: { $0.key == type })?.value
            
            guard var statistics, !statistics.isEmpty else { return }
            let currentValue = statistics.removeFirst()
            self.spinnerValues[type] = statistics
            print(spinnerValues)
            print("\(currentValue)")
            spinnerUpdateInfoPublisher.send(SpinneValueUpdateInfo(type: type, value: currentValue))
        })
    }
    
    func addStatisticsValue(type: StatisticsType, value: Double, repeatCunt: Double) {
        queue.async(flags: .barrier, execute: { [weak self] in
            guard let self else { return }
            var prevValue = self.spinnerValues.first(where: { $0.key == type} )?.value.last ?? 0.0
            var diff = value - prevValue
            
            if repeatCunt == 0 {
                self.spinnerValues[type]?.append(value)
                return
            }
            
            let coof = diff / repeatCunt
            if coof > 0.1 {
                self.spinnerValues[type]?.removeAll()
                while diff >= 0 {
                    let newValue = prevValue + coof
                    print("add")
                    print(newValue)

                    self.spinnerValues[type, default: []].append(newValue)
                    diff -= coof
                    prevValue += coof
                }

            } else {
                return self.addStatisticsValue(type: type, value: value, repeatCunt: repeatCunt / 2)
            }
        })
    }
    
}

