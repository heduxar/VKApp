//
//  CollectionImage.swift
//  VKapp
//
//  Created by Юрий Султанов on 17.07.2019.
//  Copyright © 2019 Юрий Султанов. All rights reserved.
//

import UIKit

class CollectionImage: UIImageView {
    @IBInspectable var borderColor: UIColor = .gray
    @IBInspectable var borderWidth: CGFloat = 1.5
    @IBInspectable var cornerRadius: CGFloat = 20
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = cornerRadius
        self.layer.masksToBounds = true
        self.layer.borderWidth = borderWidth
        self.layer.borderColor = borderColor.cgColor
    }
}
