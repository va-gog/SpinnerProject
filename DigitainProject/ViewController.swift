//
//  ViewController.swift
//  DigitainProject
//
//  Created by Gohar Vardanyan on 8/2/24.
//

import UIKit
import Combine

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    private var collectionView: UICollectionView?
    private var swipeHandler: StatisticsCollectionSwipeHandler?
    private var manager: StatisticsViewModel?
    private var cancellable = [AnyCancellable]()
    
    private let theme = MainScreenTheme()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        swipeHandler = StatisticsCollectionSwipeHandler()
        manager = StatisticsViewModel(networkManager: NetworkManager(),
                                     spinnerValueManager: SpinnerValueManager(),
                                     spinnerItemValues: [StatisticsItemPresentationModel(type: .clubs,
                                                                                     icon: StatisticsType.clubs.icon,
                                                                                     value: 0.0)],
                                     spinnerViewInfo: nil,
                                      urlString: theme.statisticsURL)
        
        setupSpinner()
        setupObservers()
        Task {
            await self.manager?.startSpinning()
        }
    }
    
    private func setupObservers() {
        manager?.$spinnerItemsCount.sink(receiveValue: { [weak self] _ in
            DispatchQueue.main.async {
                self?.collectionView?.reloadData()
            }
        })
        .store(in: &cancellable)
        
        manager?.spinnerUpdateInfoPublisher.sink(receiveValue: { [weak self] updateInfo in
                DispatchQueue.main.async {
                    guard let offset = updateInfo?.type.rawValue,
                          let cell = self?.collectionView?.cellForItem(at: IndexPath(item: offset, section: 0)) as? StatisticsCollectionViewCell  else { return }
                    cell.updateSpinnerWithValue(updateInfo?.value, fractionDigits: self?.manager?.spinnerViewInfo?.digitsAfterPoint ?? 0)
                }
        })
        .store(in: &cancellable)
    }
    
    private func setupSpinner() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: view.bounds.width - 2 * theme.minimumInteritemSpacing,
                                 height: theme.itemHeight)
        layout.sectionInset = UIEdgeInsets(top: theme.horizontalInset,
                                           left: theme.verticalInset,
                                           bottom: theme.horizontalInset,
                                           right: theme.verticalInset)
        layout.minimumInteritemSpacing = theme.minimumInteritemSpacing
        
        let collectionView = UICollectionView(frame: self.view.bounds, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .clear
        
        collectionView.register(StatisticsCollectionViewCell.self, forCellWithReuseIdentifier: StatisticsCollectionViewCell.reusableIdentifier)
        
        view.addSubview(collectionView)
        self.collectionView = collectionView
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor,constant: theme.statiticsViewTopAncor),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            collectionView.heightAnchor.constraint(equalToConstant: theme.itemHeight)
        ])
    }
    
    // MARK: UICollectionViewDataSource

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return manager?.spinnerItemsCount ?? 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: StatisticsCollectionViewCell.reusableIdentifier, for: indexPath) as? StatisticsCollectionViewCell,
              let model = manager?.spinnerItemValues[indexPath.item] else {
            fatalError("Cell must be SpinnerCollectionViewCelltype")
        }
        
        cell.configure(typeIcon: UIImage(named: model.icon),
                       number: model.value,
                       currencyIcon: manager?.spinnerViewInfo?.icon,
                       fractionDigits: manager?.spinnerViewInfo?.digitsAfterPoint ?? theme.digitsAfterPoint)
        return cell
    }
    
    // MARK: UICollectionViewDelegate

    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate, let index = swipeHandler?.collectionViewDidEndScrolling(profilesCollectionView: scrollView)?.item {
            manager?.scrollToStatistics(type: StatisticsType(rawValue: index))
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView)  {
        guard  let index = swipeHandler?.collectionViewDidEndScrolling(profilesCollectionView: scrollView)?.item else { return }
        manager?.scrollToStatistics(type: StatisticsType(rawValue: index))
    }
}

