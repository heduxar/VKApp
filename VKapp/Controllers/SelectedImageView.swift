//
//  SelectedImageView.swift
//  VKapp
//
//  Created by Юрий Султанов on 17.07.2019.
//  Copyright © 2019 Юрий Султанов. All rights reserved.
//

import UIKit

class SelectedImageView: UIViewController, UIScrollViewDelegate {
    var images = [UIImage?]()
    var indexPhoto = Int()
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var heart: UIImageView!
    @IBAction func back() {
        dismiss(animated: true, completion: nil)
    }
    private var propertyAnimator: UIViewPropertyAnimator!
    private var liked = false{
        didSet{
            if !liked {
                UIView.transition(with: heart, duration: 0.3, options: .transitionFlipFromTop, animations: {
                    self.heart.image = UIImage(named: "heart_filled")
                }, completion: nil)
            } else {
                UIView.transition(with: heart, duration: 0.3, options: .transitionFlipFromTop, animations: {
                    self.heart.image = UIImage(named: "heart_empty")
                }, completion: nil)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.image = images[indexPhoto]
        print(images.count)
        print(indexPhoto)
        addSwipe()
    }
    
    func addSwipe() {
        let swipeImage = UISwipeGestureRecognizer(target: self, action: #selector(swipeDown))
        let zoomImage = UIPinchGestureRecognizer(target: self, action: #selector(zoom))
        let likePressed = UITapGestureRecognizer(target: self, action: #selector(like))
        let doubleTabLike = UITapGestureRecognizer(target: self, action: #selector(like))
//        let previosPhoto = UISwipeGestureRecognizer(target: self, action: #selector(swipeRight))
//        let nextPhoto = UISwipeGestureRecognizer(target: self, action: #selector(swipeLeft))
        let testPanSwipe = UIPanGestureRecognizer(target: self, action: #selector(panRecognizer))
        testPanSwipe.maximumNumberOfTouches = 1
        swipeImage.direction = .down
        likePressed.numberOfTapsRequired = 1
        doubleTabLike.numberOfTapsRequired = 2
//        previosPhoto.direction = .right
//        nextPhoto.direction = .left
        imageView.addGestureRecognizer(swipeImage)
        imageView.addGestureRecognizer(zoomImage)
        imageView.addGestureRecognizer(doubleTabLike)
        imageView.addGestureRecognizer(testPanSwipe)
//        imageView.addGestureRecognizer(previosPhoto)
//        imageView.addGestureRecognizer(nextPhoto)
        heart.addGestureRecognizer(likePressed)
    }
    @objc private func panRecognizer(_ recognizer: UIPanGestureRecognizer){
        switch recognizer.state {
        case .began:
            print("Pan started")
            propertyAnimator = UIViewPropertyAnimator (duration: 3, curve: .easeOut, animations: {
                if (recognizer.translation(in: self.imageView).x/100) > 0{
                    if self.indexPhoto > 0 {
                        print(self.indexPhoto)
                        self.indexPhoto -= 1
                        UIView.transition(with: self.imageView, duration: 0.5, options: .transitionFlipFromLeft, animations: {
                            self.imageView.image = self.images[self.indexPhoto]
                        }, completion: nil)
                    }
                }else {
                    if self.indexPhoto < self.images.count-1 {
                        print(self.indexPhoto)
                        self.indexPhoto += 1
                        UIView.transition(with: self.imageView, duration: 0.5, options: .transitionFlipFromRight, animations: {
                            self.imageView.image = self.images[self.indexPhoto]
                        }, completion: nil)
                    }
                }
                
            })
            propertyAnimator.pauseAnimation()
        case .changed:
            let translation = recognizer.translation(in: self.imageView)
            print(translation)
            let percent = translation.x / 100
            print(percent)
            let animationPercent = min(1, max(0, percent))
            print(animationPercent)
            propertyAnimator.fractionComplete = animationPercent
        case .ended:
            propertyAnimator.continueAnimation(withTimingParameters: nil, durationFactor: 0.4)
        default:
            break
        }
    }
    @objc private func swipeRight (_ recognizer: UISwipeGestureRecognizer){
        if recognizer.state == .ended {
            if indexPhoto > 0 {
                print(indexPhoto)
                indexPhoto -= 1
                UIView.transition(with: imageView, duration: 0.5, options: .transitionFlipFromLeft, animations: {
                    self.imageView.image = self.images[self.indexPhoto]
                }, completion: nil)
                
            }
        }
    }
    @objc private func swipeLeft (_ recognizer: UISwipeGestureRecognizer){
        if recognizer.state == .ended {
            if indexPhoto < images.count-1 {
                print(indexPhoto)
                indexPhoto += 1
                UIView.transition(with: imageView, duration: 0.5, options: .transitionFlipFromRight, animations: {
                    self.imageView.image = self.images[self.indexPhoto]
                }, completion: nil)
            }
        }
    }
    @objc private func swipeDown(_ recognizer: UISwipeGestureRecognizer) {
        if recognizer.state == .recognized {
            back()
        }
    }
    @objc private func zoom(_ recognizer: UIPinchGestureRecognizer){
        if recognizer.state == .ended || recognizer.state == .changed {
            let currentScale = self.imageView.frame.size.width / self.imageView.bounds.size.width
            var newScale = currentScale*recognizer.scale
            if newScale < 1 {
                newScale = 1
            }
            if newScale > 3 {
                newScale = 3
            }
            let transform = CGAffineTransform(scaleX: newScale, y: newScale)
            self.imageView.transform = transform
            recognizer.scale = 1
            
        }
    }
    @objc private func like(_ recognizer: UITapGestureRecognizer){
        if recognizer.state == .recognized{
            liked.toggle()
        }
    }
    
}
