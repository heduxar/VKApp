//
//  CollectionViewCell.swift
//  VKapp
//
//  Created by Юрий Султанов on 06.07.2019.
//  Copyright © 2019 Юрий Султанов. All rights reserved.
//

import UIKit
import Kingfisher

class CollectionCell: UICollectionViewCell {
    @IBOutlet var img: CollectionImage!
    
    public func configurePhotos(with photo: Photo?) {
        guard let photo = photo else {return}
        img.kf.setImage(with: URL(string: photo.urlSmallPhoto))
    }
    public func configurePhotoCell (photo: Photo?, by photoService: PhotoService){
        guard let photo = photo else {return}
        let url = photo.urlSmallPhoto
        photoService.photo(urlString: url) {[weak self] image in
            self?.img.image = image
        }
    }
}
