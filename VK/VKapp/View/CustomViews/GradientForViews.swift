//
//  GradientView.swift
//  GeekbrainsWeather
//
//  Created by user on 11/04/2019.
//  Copyright © 2019 Morizo Digital. All rights reserved.
//

import UIKit

@IBDesignable class GradientForViews: UIView {
    
    //MARK: - Overriding layer class in order to make it Gradient
    override static var layerClass: AnyClass {
        return CAGradientLayer.self
    }
    
    //MARK: - Computed property to make layer easy accessable
    public var gradientLayer: CAGradientLayer {
        return self.layer as! CAGradientLayer
    }
    
    //MARK: - Class configuiring properties
    @IBInspectable var startColor: UIColor = .white {
        didSet {
            self.updateColors()
        }
    }
    @IBInspectable var endColor: UIColor = .black {
        didSet {
            self.updateColors()
        }
    }
    @IBInspectable var startLocation: CGFloat = 0 {
        didSet {
            self.updateLocations()
        }
    }
    @IBInspectable var endLocation: CGFloat = 1 {
        didSet {
            self.updateLocations()
        }
    }
    @IBInspectable var startPoint: CGPoint = .zero {
        didSet {
            self.updateStartPoint()
        }
    }
    @IBInspectable var endPoint: CGPoint = CGPoint(x: 0, y: 1) {
        didSet {
            self.updateEndPoint()
        }
    }
    
    //MARK: - Class configuiring methods
    func updateLocations() {
        self.gradientLayer.locations = [self.startLocation as NSNumber,
                                        self.endLocation as NSNumber]
    }
    
    func updateColors() {
        self.gradientLayer.colors = [self.startColor.cgColor, self.endColor.cgColor]
    }
    
    func updateStartPoint() {
        self.gradientLayer.startPoint = startPoint
    }
    
    func updateEndPoint() {
        self.gradientLayer.endPoint = endPoint
    }
}
