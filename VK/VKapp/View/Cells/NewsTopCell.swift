//
//  NewsTopCell.swift
//  VKapp
//
//  Created by Юрий Султанов on 17.09.2019.
//  Copyright © 2019 Юрий Султанов. All rights reserved.
//

import UIKit

class NewsTopCell: UITableViewCell {
    @IBOutlet var avatar: AvatarImage!
    @IBOutlet var name: UILabel!
    @IBOutlet var date: UILabel!
    
    public func configureNewsTop(with news: News?) {
        guard let news = news else {return}
        avatar.kf.setImage(with: URL(string: news.avatar))
        name.text = news.name
        date.text = news.date.toString(dateFormat: "HH:mm dd-MM-yy")
    }
}
