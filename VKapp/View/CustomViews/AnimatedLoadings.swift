////
////  AnimatedLoadings.swift
////  VKapp
////
////  Created by Юрий Султанов on 07.08.2019.
////  Copyright © 2019 Юрий Султанов. All rights reserved.
////
//
//import UIKit
//
//class LoadingViewController: UIViewController {
//    @IBOutlet var loading: UIView!
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//    }
//
//    override func viewWillAppear(_ animated: Bool) {
//        loadingAnimate()
//        loadingAnimate2()
//        loadingAnimate3()
//    }
//
//    private func loadingAnimate() {
//        let otstup: CGFloat = 20
//
//        let pointLayer1 = CAShapeLayer()
//        pointLayer1.backgroundColor = UIColor.gray.cgColor
//        pointLayer1.bounds = CGRect(x: 0, y: 0, width: 15, height: 15)
//        pointLayer1.cornerRadius = pointLayer1.bounds.width/2
//        pointLayer1.position = CGPoint(x: loadingView.bounds.midX - otstup, y: loadingView.bounds.midY)
//        pointLayer1.shadowOpacity = 0.2
//
//        loadingView.layer.addSublayer(pointLayer1)
//
//        let pointLayer2 = CAShapeLayer()
//        pointLayer2.backgroundColor = UIColor.gray.cgColor
//        pointLayer2.bounds = CGRect(x: 0, y: 0, width: 15, height: 15)
//        pointLayer2.cornerRadius = pointLayer2.bounds.width/2
//        pointLayer2.position = CGPoint(x: loadingView.bounds.midX, y: loadingView.bounds.midY)
//        pointLayer2.shadowOpacity = 0.2
//
//        loadingView.layer.addSublayer(pointLayer2)
//
//        let pointLayer3 = CAShapeLayer()
//        pointLayer3.backgroundColor = UIColor.gray.cgColor
//        pointLayer3.bounds = CGRect(x: 0, y: 0, width: 15, height: 15)
//        pointLayer3.cornerRadius = pointLayer3.bounds.width/2
//        pointLayer3.position = CGPoint(x: loadingView.bounds.midX + otstup, y: loadingView.bounds.midY)
//        pointLayer3.shadowOpacity = 0.2
//
//        loadingView.layer.addSublayer(pointLayer3)
//
//        let animation1 = CASpringAnimation(keyPath: #keyPath(CAShapeLayer.opacity))
//        animation1.fromValue = 1
//        animation1.toValue = 0
//        animation1.duration = 1
//        animation1.damping = 1
//        animation1.initialVelocity = 2
//        animation1.stiffness = 200
//        animation1.mass = 12
//        animation1.repeatCount = .infinity
//        animation1.autoreverses = true
//        animation1.beginTime = CACurrentMediaTime()
//
//        pointLayer1.add(animation1, forKey: nil)
//
//        let animation2 = CASpringAnimation(keyPath: #keyPath(CAShapeLayer.opacity))
//        animation2.fromValue = 1
//        animation2.toValue = 0
//        animation2.duration = 1
//        animation2.damping = 1
//        animation2.initialVelocity = 2
//        animation2.stiffness = 200
//        animation2.mass = 12
//        animation2.repeatCount = .infinity
//        animation2.autoreverses = true
//        animation2.beginTime = CACurrentMediaTime() + 0.5
//
//        pointLayer2.add(animation2, forKey: nil)
//
//        let animation3 = CASpringAnimation(keyPath: #keyPath(CAShapeLayer.opacity))
//        animation3.fromValue = 1
//        animation3.toValue = 0
//        animation3.duration = 1
//        animation3.damping = 1
//        animation3.initialVelocity = 2
//        animation3.stiffness = 200
//        animation3.mass = 12
//        animation3.repeatCount = .infinity
//        animation3.autoreverses = true
//        animation3.beginTime = CACurrentMediaTime() + 1
//
//        pointLayer3.add(animation3, forKey: nil)
//    }
//
//    let loadingLogo: UIBezierPath = {
//        let path = UIBezierPath()
//        path.addArc(withCenter: .init(x: 200, y: 300), radius: 30, startAngle: -0.00001, endAngle: 0, clockwise: false)
//        return path
//    }()
//
//    private func loadingAnimate2() {
//        let layer = CAShapeLayer()
//        layer.path = loadingLogo.cgPath
//        layer.lineWidth = 1
//        layer.strokeColor = UIColor.gray.cgColor
//        layer.fillColor = UIColor.clear.cgColor
//        layer.shadowOpacity = 0.3
//        loadingView.layer.addSublayer(layer)
//
//        let strokeEndAnimation = CABasicAnimation(keyPath: #keyPath(CAShapeLayer.strokeEnd))
//        strokeEndAnimation.fromValue = 0
//        strokeEndAnimation.toValue = 1
//
//        let strokeStartAnimation = CABasicAnimation(keyPath: #keyPath(CAShapeLayer.strokeStart))
//        strokeStartAnimation.fromValue = -0.1
//        strokeStartAnimation.toValue = 0.9
//
//        let strokeMidAnimation = CABasicAnimation(keyPath: #keyPath(CAShapeLayer.strokeStart))
//        strokeStartAnimation.fromValue = 1
//        strokeStartAnimation.toValue = 1
//
//        let animationGroup = CAAnimationGroup()
//        animationGroup.animations = [strokeEndAnimation, strokeStartAnimation, strokeMidAnimation]
//        animationGroup.repeatCount = .infinity
//        animationGroup.duration = 1
//        animationGroup.timingFunction = CAMediaTimingFunction(controlPoints: 0.8, 0.73, 0.48, 1)
//
//        layer.add(animationGroup, forKey: nil)
//    }
//
//    private func loadingAnimate3() {
//        let pointLayer = CAShapeLayer()
//        pointLayer.backgroundColor = UIColor.red.cgColor
//        pointLayer.cornerRadius = 5
//        pointLayer.bounds = CGRect(x: 0, y: 0, width: 10, height: 10)
//        pointLayer.position = CGPoint(x: 0, y: 0)
//        pointLayer.shadowOpacity = 0.1
//
//        loadingView.layer.addSublayer(pointLayer)
//
//        let animation = CAKeyframeAnimation(keyPath: "position")
//        animation.path = loadingLogo.cgPath
//        animation.calculationMode = .cubicPaced
//        animation.duration = 1
//        animation.repeatCount = .infinity
//        animation.timingFunction = CAMediaTimingFunction(controlPoints: 0.8, 0.73, 0.48, 1)
//
//        pointLayer.add(animation, forKey: nil)
//
//    }
//
//
//
//
//}
