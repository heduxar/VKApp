//
//  CollectionViewController.swift
//  VKapp
//
//  Created by Юрий Султанов on 06.07.2019.
//  Copyright © 2019 Юрий Султанов. All rights reserved.
//

import UIKit

class UserImagesView: UICollectionViewController {
    
    @IBAction func backToImages(_ unwindSegue: UIStoryboardSegue) {}
    fileprivate let scaleUpAnimator = ScaleUpAnimator()
    let networkService = NetworkService()
    public var userId: Int = 1
    public var images = [Photo]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        networkService.getPhotos(userId: userId) { [weak self] photos in
            guard let self = self else {return}
            self.images = photos
            self.collectionView.reloadData()
        }
    }
//
//    override func numberOfSections(in collectionView: UICollectionView) -> Int {
//        return 1
//    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionCell", for: indexPath) as! CollectionCell
        let img = images[indexPath.item]
        cell.configurePhotos(with: img)
        let opacity = CABasicAnimation(keyPath: #keyPath(CALayer.opacity))
        opacity.fromValue = 0
        opacity.toValue = 1
        let scale = CABasicAnimation(keyPath: "transform.scale")
        scale.fromValue = 0.1
        scale.toValue = 1
        let animGroup = CAAnimationGroup ()
        animGroup.duration = 1
        animGroup.animations = [opacity, scale]
        
        cell.layer.add(animGroup, forKey: nil)
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        print("🏳️")
//        performSegue(withIdentifier: "selectedImage", sender: indexPath.item)
        let storyboard = UIStoryboard(name: "inside", bundle: nil)
        let bigPhotoController = storyboard.instantiateViewController(withIdentifier: "bigImageView")
        bigPhotoController.transitioningDelegate = self
        
        if let destination = bigPhotoController as? SelectedImageView {
            guard collectionView.indexPathsForSelectedItems?.count == 1 else { return }
            let selectedItem = collectionView.indexPathsForSelectedItems![0].item
            destination.indexPhoto = selectedItem
            destination.images = images
        }
        present(bigPhotoController, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "selectedImage",
            let selectedImageVC = segue.destination as? SelectedImageView {
            guard let indexPath = sender as? Int else {return}
            selectedImageVC.images = images
            selectedImageVC.indexPhoto = indexPath
        }
    }
}

extension UserImagesView: UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return scaleUpAnimator
    }
}
