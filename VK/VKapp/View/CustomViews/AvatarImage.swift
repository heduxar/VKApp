//
//  AvatarImage.swift
//  VKapp
//
//  Created by Юрий Султанов on 13.07.2019.
//  Copyright © 2019 Юрий Султанов. All rights reserved.
//

import UIKit

class AvatarImage: UIImageView {
    @IBInspectable var borderColor: UIColor = .gray
    @IBInspectable var borderWidth: CGFloat = 1.5
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = self.frame.height / 2
        self.layer.masksToBounds = true
        self.layer.borderWidth = borderWidth
        self.layer.borderColor = borderColor.cgColor

    }
}
