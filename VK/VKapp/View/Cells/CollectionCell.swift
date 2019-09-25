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
//        name.text = group.name
//        avatar.kf.setImage(with: URL(string: group.avatar))
    }
}
