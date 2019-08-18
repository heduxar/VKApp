//
//  ForecastCollectionLayout.swift
//  GeekbrainsWeather
//
//  Created by user on 18/04/2019.
//  Copyright © 2019 Morizo Digital. All rights reserved.
//

import UIKit

class LayoutForCollection: UICollectionViewLayout {
    
    var cacheAttributes = [IndexPath: UICollectionViewLayoutAttributes]()
    var columnsCount = 4
    var cellHeight: CGFloat = 128
    private var totalCellsHeight: CGFloat = 0
    
    override func prepare() {
        super.prepare()
        
        cacheAttributes = [:]
        guard let collectionView = self.collectionView else { return }
        
        let itemsCount = collectionView.numberOfItems(inSection: 0)
        guard itemsCount > 0 else { return }
        
        let bigCellWidth = collectionView.bounds.width
        let smallCellWidth = collectionView.bounds.width / CGFloat(columnsCount)
        
        var lastY: CGFloat = 0
        var lastX: CGFloat = 0
        
        for index in 0..<itemsCount {
            let indexPath = IndexPath(item: index, section: 0)
            let attributtes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            
            let isBigCell = (((index + 1) % (columnsCount + 1)) == 0)
            
            if isBigCell {
                attributtes.frame = CGRect(x: 0, y: lastY, width: bigCellWidth, height: cellHeight)
//                attributtes.
                lastY += cellHeight
            } else {
                attributtes.frame = CGRect(x: lastX, y: lastY, width: smallCellWidth, height: cellHeight)
                
                let isLastColumn = (index + 2) % (columnsCount + 1) == 0 || index == (itemsCount - 1)
                
                if isLastColumn {
                    lastX = 0
                    lastY += cellHeight
                } else {
                    lastX += smallCellWidth
                }
            }
            cacheAttributes[indexPath] = attributtes
        }
        totalCellsHeight = lastY
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return cacheAttributes.values.filter { attributes in
            rect.intersects(attributes.frame)
        }
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return cacheAttributes[indexPath]
    }
    
    override var collectionViewContentSize: CGSize {
        return CGSize(width: collectionView?.bounds.width ?? 0,
                      height: totalCellsHeight)
    }
}
