//
//  CustomNavShow.swift
//  VKapp
//
//  Created by Юрий Султанов on 02.08.2019.
//  Copyright © 2019 Юрий Султанов. All rights reserved.
//

import UIKit

class CustomNavShow: NSObject, UIViewControllerAnimatedTransitioning {
    var animationDuration: TimeInterval = 1
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return animationDuration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let sourceVC = transitionContext.viewController(forKey: .from),
            let destinationVC = transitionContext.viewController(forKey: .to) else {preconditionFailure("error with path from souceVC to destinationVC")}
        transitionContext.containerView.addSubview(destinationVC.view)
        
        sourceVC.view.frame = transitionContext.containerView.frame
        destinationVC.view.frame = transitionContext.containerView.frame
        destinationVC.view.layer.position = CGPoint(x: sourceVC.view.frame.maxX,
                                                    y: sourceVC.view.frame.minY)
        destinationVC.view.layer.anchorPoint = CGPoint(x: 1, y: 0)
        destinationVC.view.transform = CGAffineTransform (rotationAngle: .pi/2)
        UIView.animateKeyframes(withDuration: animationDuration, delay: 0, options: .calculationModeCubic, animations: {
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.75, animations: {
                let scale = CGAffineTransform(scaleX: 0.9, y: 0.9)
                sourceVC.view.transform = scale
            })
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.6, animations: {
                let translation = CGAffineTransform(rotationAngle: -(.pi/2))
                let scale = CGAffineTransform(scaleX: 1.1, y: 1.1)
                destinationVC.view.transform = translation.concatenating(scale)
            })
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.4, animations: {
                destinationVC.view.transform = .identity
            })
        }){ done in
            if done && !transitionContext.transitionWasCancelled {
                sourceVC.view.transform = .identity
            }
            transitionContext.completeTransition (done && !transitionContext.transitionWasCancelled)
        }
    }
}

class CustomNavBack: NSObject, UIViewControllerAnimatedTransitioning {
    let animationDuration: TimeInterval = 1
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return animationDuration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let sourceVC = transitionContext.viewController(forKey: .from),
            let destinationVC = transitionContext.viewController(forKey: .to) else {preconditionFailure("error with path from souceVC to destinationVC")}
        transitionContext.containerView.addSubview(destinationVC.view)
        transitionContext.containerView.sendSubviewToBack(destinationVC.view)
        sourceVC.view.frame = transitionContext.containerView.frame
        sourceVC.view.layer.position = CGPoint(x: sourceVC.view.frame.maxX,
                                               y: sourceVC.view.frame.minY)
        sourceVC.view.layer.anchorPoint = CGPoint(x: 1, y: 0)
        destinationVC.view.frame = transitionContext.containerView.frame
        destinationVC.view.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        
        UIView.animateKeyframes(withDuration: animationDuration, delay: 0, options: .calculationModeCubic, animations: {
            UIView.addKeyframe(withRelativeStartTime: 0.25, relativeDuration: 0.75, animations: {
                destinationVC.view.transform = .identity
            })
            
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.1, animations: {
                let translation = CGAffineTransform(rotationAngle: -.pi/2)
                let scale = CGAffineTransform(scaleX: 1.2, y: 1.2)
                sourceVC.view.transform = translation.concatenating(scale)
            })
        }) { finished in
            if finished && !transitionContext.transitionWasCancelled {
                sourceVC.removeFromParent()
            } else if transitionContext.transitionWasCancelled {
                destinationVC.view.transform = .identity
            }
            transitionContext.completeTransition(finished && !transitionContext.transitionWasCancelled)
        }
    }
}
