//
//  SelectedImageView.swift
//  VKapp
//
//  Created by Юрий Султанов on 17.07.2019.
//  Copyright © 2019 Юрий Султанов. All rights reserved.
//

import UIKit
import Kingfisher
import RealmSwift

class SelectedImageViewController: UIViewController, UIScrollViewDelegate {
    var userId: Int = 0
    var indexPhoto = Int()
    private lazy var images = try? Realm().objects(Photo.self).filter("owner_id == %@", userId)
    let networkService = NetworkService()
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var heart: UIImageView!
    @IBOutlet var likeCounter: UILabel!
    @IBOutlet var repostCounter: UILabel!
    @IBOutlet var commentCounter: UILabel!
    
    
    @IBAction func back() {
        dismiss(animated: true, completion: nil)
    }
    private var propertyAnimator: UIViewPropertyAnimator!
    private var liked = false{
        didSet{
            if liked {
                UIView.transition(with: heart, duration: 0.3, options: .transitionFlipFromTop, animations: {
                    self.heart.image = UIImage(named: "heart_filled")
                    guard let imageId = self.images?[self.indexPhoto].id else {return}
                    let photo = try? Realm().objects(Photo.self).filter("id == %@", imageId)
                    try? Realm().write {
                            photo?.setValue(1, forKey: "user_likes")
                    }
                }, completion: nil)
            } else {
                UIView.transition(with: heart, duration: 0.3, options: .transitionFlipFromTop, animations: {
                    self.heart.image = UIImage(named: "heart_empty")
                    guard let imageId = self.images?[self.indexPhoto].id else {return}
                    let photo = try? Realm().objects(Photo.self).filter("id == %@", imageId)
                    try? Realm().write {
                        photo?.setValue(0, forKey: "user_likes")
                    }
                }, completion: nil)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setImage(indexPhoto: indexPhoto)
        addSwipe()
    }
    private func setImage (indexPhoto: Int) {
        self.imageView.transform = .identity
        imageView.kf.setImage(with: URL(string: images![indexPhoto].urlBigPhoto))
        likeCounter.text = String(images![indexPhoto].likes)
        repostCounter.text = String(images![indexPhoto].reposts)
        images![indexPhoto].user_likes > 0 ? (self.liked = true) : (self.liked = false)
    }
    func addSwipe() {
        let swipeImage = UISwipeGestureRecognizer(target: self, action: #selector(swipeDown))
        let zoomImage = UIPinchGestureRecognizer(target: self, action: #selector(zoom))
        let likePressed = UITapGestureRecognizer(target: self, action: #selector(like))
        let doubleTabLike = UITapGestureRecognizer(target: self, action: #selector(like))
        //        let previosPhoto = UISwipeGestureRecognizer(target: self, action: #selector(swipeRight))
        //        let nextPhoto = UISwipeGestureRecognizer(target: self, action: #selector(swipeLeft))
        let edgePanSwipe = UIPanGestureRecognizer(target: self, action: #selector(panRecognizer))
        //        UIScreenEdgePanGestureRecognizer
        edgePanSwipe.maximumNumberOfTouches = 1
        swipeImage.direction = .down
        likePressed.numberOfTapsRequired = 1
        doubleTabLike.numberOfTapsRequired = 2
        //        previosPhoto.direction = .right
        //        nextPhoto.direction = .left
        imageView.addGestureRecognizer(swipeImage)
        imageView.addGestureRecognizer(zoomImage)
        imageView.addGestureRecognizer(doubleTabLike)
        imageView.addGestureRecognizer(edgePanSwipe)
        //        imageView.addGestureRecognizer(previosPhoto)
        //        imageView.addGestureRecognizer(nextPhoto)
        heart.addGestureRecognizer(likePressed)
    }
    @objc private func panRecognizer(_ recognizer: UIPanGestureRecognizer){
        switch recognizer.state {
        case .began:
            propertyAnimator = UIViewPropertyAnimator (duration: 3, curve: .easeOut, animations: {
                if (recognizer.translation(in: self.imageView).x/100) > 0{
                    if self.indexPhoto > 0 {
                        self.indexPhoto -= 1
                        UIView.transition(with: self.imageView, duration: 0.5, options: .transitionFlipFromLeft, animations: {
                            self.setImage(indexPhoto: self.indexPhoto)
                            //                            self.imageView.image = self.images[self.indexPhoto]
                        }, completion: nil)
                    }
                }else {
                    guard let count = self.images?.count else {return}
                    if self.indexPhoto < count-1 {
                        self.indexPhoto += 1
                        UIView.transition(with: self.imageView, duration: 0.5, options: .transitionFlipFromRight, animations: {
                            self.setImage(indexPhoto: self.indexPhoto)
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
                    self.setImage(indexPhoto: self.indexPhoto)
                    //                    self.imageView.image = self.images[self.indexPhoto]
                }, completion: nil)
                
            }
        }
    }
    @objc private func swipeLeft (_ recognizer: UISwipeGestureRecognizer){
        if recognizer.state == .ended {
            guard let count = self.images?.count else {return}
            if indexPhoto < count-1 {
                print(indexPhoto)
                indexPhoto += 1
                UIView.transition(with: imageView, duration: 0.5, options: .transitionFlipFromRight, animations: {
                    self.setImage(indexPhoto: self.indexPhoto)
                    //                    self.imageView.image = self.images[self.indexPhoto]
                }, completion: nil)
            }
        }
    }
    @objc private func swipeDown(_ recognizer: UISwipeGestureRecognizer) {
        if recognizer.state == .recognized {
            dismiss(animated: true, completion: nil)
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
            if images?[indexPhoto].user_likes == 0 {
                networkService.likesAdd(ownerId: images![indexPhoto].owner_id, itemId: images![indexPhoto].id, type: images![indexPhoto].type) { [weak self] likes in
                    guard let self = self else {return}
                    self.likeCounter.text = String(likes)
                    self.liked.toggle()
                }
            } else {
                networkService.likesDelete(ownerId: images![indexPhoto].owner_id, itemId: images![indexPhoto].id, type: "photo") { [weak self] likes in
                    guard let self = self else {return}
                    self.likeCounter.text = String(likes)
                    self.liked.toggle()
                }
            }
        }
    }
}
