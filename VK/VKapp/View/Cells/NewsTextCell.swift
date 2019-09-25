//
//  NewsContentText.swift
//  VKapp
//
//  Created by Юрий Султанов on 17.09.2019.
//  Copyright © 2019 Юрий Султанов. All rights reserved.
//

import UIKit

class NewsTextCell: UITableViewCell {
    @IBOutlet var newsText: UITextView!
    public func configureNewsTextCell (with news: News?) {
        guard let text = news?.newsText else {return}
        newsText.text = text
    }
}
