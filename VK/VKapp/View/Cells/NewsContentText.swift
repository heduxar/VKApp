//
//  NewsContentText.swift
//  VKapp
//
//  Created by Юрий Султанов on 17.09.2019.
//  Copyright © 2019 Юрий Султанов. All rights reserved.
//

import UIKit

class NewsContentText: UITableViewCell {
    @IBOutlet var newsText: UITextView!
    public func configureNewsContentText (with news: News?) {
        guard let news = news else {return}
        textView.text = news.newsText
    }
}
