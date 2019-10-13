//
//  ScaleUpPhotos.swift
//  VKapp
//
//  Created by Юрий Султанов on 07.08.2019.
//  Copyright © 2019 Юрий Султанов. All rights reserved.
//

import UIKit

class ScaleUpAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
    private let animationDuration: TimeInterval = 1
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return animationDuration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        guard let source = transitionContext.viewController(forKey: .from) ,
            let destination = transitionContext.viewController(forKey: .to)  else { return }
        
        let userImagesControllers = source.children[1].children.filter { $0 is UserImagesViewController }
        
        guard let userImagesView = userImagesControllers.first as? UserImagesViewController,
            let selectedItems = userImagesView.collectionView.indexPathsForSelectedItems,
            let indexPath = selectedItems.first,
            let cell = userImagesView.collectionView.cellForItem(at: indexPath),
            let snapshot = cell.contentView.snapshotView(afterScreenUpdates: false) else { return }
        
        userImagesView.view.addSubview(snapshot)
        snapshot.contentMode = .scaleAspectFit
        snapshot.backgroundColor = .darkGray
        
        let topBarHeight = userImagesView.navigationController!.navigationBar.bounds.height + UIApplication.shared.statusBarFrame.height
        snapshot.frame = CGRect(x: cell.frame.origin.x, y: cell.frame.origin.y + topBarHeight, width: cell.frame.width, height: cell.frame.height)
        
        UIView.animate(withDuration: 0.5, animations: {
            snapshot.frame = userImagesView.view.bounds
        }) { completed in
            transitionContext.containerView.addSubview(destination.view)
            destination.view.frame = transitionContext.containerView.frame
            snapshot.removeFromSuperview()
            
            transitionContext.completeTransition(completed)
        }
    }
}
