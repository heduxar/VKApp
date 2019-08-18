//
//  TableViewCell.swift
//  VKapp
//
//  Created by Юрий Султанов on 26.07.2019.
//  Copyright © 2019 Юрий Султанов. All rights reserved.
//

import UIKit

struct News {
    let avatar: UIImage
    let name: String
    var newsText: String
    var photos = [UIImage]()
    var likesCounter: String = "0"
    init(Avatar: UIImage, Name: String, Text: String, Photos: [UIImage]) {
        self.avatar = Avatar
        self.name = Name
        self.newsText = Text
        self.photos = Photos
    }
    init(Avatar: UIImage, Name: String, Text: String) {
        self.avatar = Avatar
        self.name = Name
        self.newsText = Text
    }
}
