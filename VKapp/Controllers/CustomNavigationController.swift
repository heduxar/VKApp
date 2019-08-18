//
//  CustomNavigation.swift
//  VKapp
//
//  Created by Юрий Султанов on 02.08.2019.
//  Copyright © 2019 Юрий Султанов. All rights reserved.
//

import UIKit
class InteractiveNavigation: UIPercentDrivenInteractiveTransition {
    var hasStarted = false
    var shouldFinish = false
}
class CustomNavigationController: UINavigationController, UINavigationControllerDelegate {
    var interactive = InteractiveNavigation()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        let edgePanGR = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:)))
        edgePanGR.edges = .left
        view.addGestureRecognizer(edgePanGR)
    }
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationController.Operation,
                              from fromVC: UIViewController,
                              to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        switch operation {
        case .push:
            return CustomNavShow()
        case .pop:
            return CustomNavBack()
        default:
            return nil
        }
    }
    func navigationController(_ navigationController: UINavigationController, interactionControllerFor animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return interactive.hasStarted ? interactive : nil
    }
    @objc private func handlePanGesture(_ recognizer: UIScreenEdgePanGestureRecognizer) {
        switch recognizer.state {
        case .began:
            interactive.hasStarted = true
            self.popViewController(animated: true)
            
        case .changed:
            guard let width = recognizer.view?.bounds.width else {
                interactive.hasStarted = false
                interactive.cancel()
                return
            }
            let translation = recognizer.translation(in: recognizer.view)
            let relativeTranslation = translation.x / width
            let progress = max(0, min(1, relativeTranslation))
            
            interactive.update(progress)
            interactive.shouldFinish = progress > 0.35
            
        case .ended:
            interactive.hasStarted = false
            interactive.shouldFinish ? interactive.finish() : interactive.cancel()
            
        case .cancelled:
            interactive.hasStarted = false
            interactive.cancel()
            
        default:
            break
        }
    }
    
}
