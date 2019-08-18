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
    public var images = [UIImage?]()
    fileprivate let scaleUpAnimator = ScaleUpAnimator()
    let networkService = NetworkServices()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        networkService.getPhotos(userId: 1)
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionCell", for: indexPath) as! CollectionCell
        let img = images[indexPath.item]
        cell.img.image = img
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
        print("🏳️")
//        performSegue(withIdentifier: "selectedImage", sender: indexPath.item)
        let storyboard = UIStoryboard(name: "inside", bundle: nil)
        let bigPhotoController = storyboard.instantiateViewController(withIdentifier: "bigImageView")
        bigPhotoController.transitioningDelegate = self
        
        if let destination = bigPhotoController as? SelectedImageView {
            guard collectionView.indexPathsForSelectedItems?.count == 1 else { return }
            let selectedRow = collectionView.indexPathsForSelectedItems![0].row
            destination.indexPhoto = selectedRow
            destination.images = images
        }
        present(bigPhotoController, animated: true)
        
        print("GOGOGO")
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
