//
//  StatisticsSwipeHandlerInterface.swift
//  DigitainProject
//
//  Created by Gohar Vardanyan on 8/5/24.
//

import UIKit

protocol StatisticsCollectionSwipeHandlerInterface {
    func collectionViewDidEndScrolling(profilesCollectionView: UIScrollView) -> IndexPath?
}
