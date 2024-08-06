//
//  StatisticsSwipeHandler.swift
//  DigitainProject
//
//  Created by Gohar Vardanyan on 05.08.24.
//

import UIKit

struct StatisticsCollectionSwipeHandler: StatisticsCollectionSwipeHandlerInterface {
    func collectionViewDidEndScrolling(profilesCollectionView: UIScrollView) -> IndexPath? {
        guard let profilesCollectionView = profilesCollectionView as? UICollectionView else { return nil }
        guard let visibleIndexPath = getSmallestVisibleIndexPath(profilesCollectionView: profilesCollectionView),
              let attributes = profilesCollectionView.layoutAttributesForItem(at: visibleIndexPath) else { return nil }
        if abs(profilesCollectionView.contentOffset.x) < attributes.frame.minX + attributes.size.width / 2 + 20 {
            profilesCollectionView.setContentOffset(CGPoint(x: attributes.frame.minX - 20,
                                                             y: profilesCollectionView.contentOffset.y),
                                                     animated: true)
            return visibleIndexPath
        } else {
            let nextIndexPath = IndexPath(item: visibleIndexPath.item + 1, section: visibleIndexPath.section)
            let nextAttributes = profilesCollectionView.layoutAttributesForItem(at: nextIndexPath) ?? attributes
            profilesCollectionView.setContentOffset(CGPoint(x: nextAttributes.frame.minX - 20,
                                                             y: profilesCollectionView.contentOffset.y),
                                                     animated: true)
            return nextIndexPath
        }
    }
    
    private func getSmallestVisibleIndexPath(profilesCollectionView: UICollectionView) -> IndexPath? {
           let visibleIndexPaths = profilesCollectionView.indexPathsForVisibleItems
           return visibleIndexPaths.sorted().first
       }
    
    private func getLargestVisibleIndexPath(profilesCollectionView: UICollectionView) -> IndexPath? {
           let visibleIndexPaths = profilesCollectionView.indexPathsForVisibleItems
           return visibleIndexPaths.sorted().last
       }
}
