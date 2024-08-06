//
//  GameStatsViewModel.swift
//  DigitainProject
//
//  Created by Gohar Vardanyan on 8/2/24.
//

import Foundation
import Combine

final class StatisticsViewModel: StatisticsViewModelProtocol {
    @Published var spinnerItemsCount: Int = 1
    var spinnerUpdateInfoPublisher = PassthroughSubject<SpinneValueUpdateInfo?, Never>()

    var spinnerViewInfo: SpinnerViewInfo?
    var spinnerItemValues: [StatisticsItemPresentationModel] = [StatisticsItemPresentationModel(type: .clubs,
                                                                                                icon: StatisticsType.clubs.icon,
                                                                                                value: 0.0)]
    private let networkManager: NetworkManagerProtocol
    private let spinnerValueManager: SpinnerValueManagerProtocol
    private var currentStatisticsType: StatisticsType
    private var urlString: String
    private var cancellable = Set<AnyCancellable>()
    
    private var updateTimer: Timer?
    private var loadingTimer: Timer?
    
    init(networkManager: NetworkManagerProtocol,
         spinnerValueManager: SpinnerValueManagerProtocol,
         spinnerItemValues: [StatisticsItemPresentationModel],
         spinnerViewInfo: SpinnerViewInfo?,
         urlString: String,
         currentStatisticsType:  StatisticsType = .clubs) {
        self.spinnerItemValues = spinnerItemValues
        self.networkManager = networkManager
        self.spinnerValueManager = spinnerValueManager
        self.currentStatisticsType = currentStatisticsType
        self.spinnerViewInfo = spinnerViewInfo
        self.urlString = urlString
        
        spinnerValueManager.spinnerUpdateInfoPublisher.sink(receiveValue: { [weak self] updateInfo in
            guard let self = self else { return }
            let model = StatisticsItemPresentationModel(type: updateInfo.type,
                                                        icon: updateInfo.type.icon,
                                                        value: updateInfo.value)
            if let index = self.spinnerItemValues.firstIndex(where: { $0.type == updateInfo.type }) {
                self.spinnerItemValues[index] = model
            }
            self.spinnerUpdateInfoPublisher.send(updateInfo) 
        })
        .store(in: &cancellable)
    }
    
    func startSpinning() async {
        networkManager.fetchAndDecode(from: urlString, as: Statistics.self)
            .sink(receiveCompletion: { completion in
                guard completion != .finished else { return }
                Task { [weak self] in
                    await self?.startSpinning()
                }
            }, receiveValue: { [weak self] statistics in
                guard let self else { return }
                
                self.spinnerViewInfo = SpinnerViewInfo(currency: statistics.currency,
                                                       icon: IconFactory().currencyIcon(statistics.currency),
                                                       digitsAfterPoint: statistics.digitsAfterPoint)
                
                self.createStatisticsPresentationModels(with: statistics)
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    self.spinnerValueManager.updateStatistics(type: .clubs)
                }
                DispatchQueue.main.async {
                    self.startTimers()
                }
            })
            .store(in: &cancellable)
    }
    
    func scrollToStatistics(type: StatisticsType?) {
        guard let type else { return }
        currentStatisticsType = type
    }
    
    private func createStatisticsPresentationModels(with statistics: Statistics) {
        var items = [StatisticsItemPresentationModel]()
        for item in statistics.items {
            if item.type == currentStatisticsType {
                items.append(StatisticsItemPresentationModel(type: .clubs,
                                                             icon: StatisticsType.clubs.icon,
                                                             value: 0.00))
            } else {
                items.append(StatisticsItemPresentationModel(type: item.type,
                                                             icon: item.type.icon,
                                                             value: item.current))
            }
            spinnerValueManager.addStatisticsValue(type: item.type, value: item.current, repeatCunt: 6)
        }
        spinnerItemsCount = items.count
        spinnerItemValues = items
    }
    
    private func startTimers() {
        updateTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTimerAction), userInfo: nil, repeats: true)
        loadingTimer = Timer.scheduledTimer(timeInterval: 6.0, target: self, selector: #selector(loadingTimerAction), userInfo: nil, repeats: true)
    }
    
    @objc private func updateTimerAction() {
        self.spinnerValueManager.updateStatistics(type: currentStatisticsType)
    }
    
    @objc private func loadingTimerAction() {
        networkManager.fetchAndDecode(from: urlString, as: Statistics.self)
            .sink(receiveCompletion: { completion in
                if case .failure = completion {
                    Task { [weak self] in
                        await self?.startSpinning()
                    }
                }
            }, receiveValue: { [weak self] statistics in
                guard let self = self,
                      let item = statistics.items.first(where: { $0.type == self.currentStatisticsType }) else { return }
                self.spinnerValueManager.addStatisticsValue(type: item.type,
                                                            value:  item.current,
                                                            repeatCunt: 6)
            })
            .store(in: &cancellable)
    }
}
