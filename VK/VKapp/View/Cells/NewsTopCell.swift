//
//  NewsTopCell.swift
//  VKapp
//
//  Created by Юрий Султанов on 17.09.2019.
//  Copyright © 2019 Юрий Султанов. All rights reserved.
//

import UIKit
import RealmSwift

class NewsTopCell: UITableViewCell {
    @IBOutlet var avatar: AvatarImage!
    @IBOutlet var name: UILabel!
    @IBOutlet var date: UILabel!
    //    private lazy var sourceId = 0
    //    private lazy var user = try? Realm().objects(User.self).filter("id == %@", sourceId)
    //    private lazy var group = try? Realm().objects(Group.self).filter("id == %@", sourceId)
    
    public func configureNewsTop(with news: News?) {
        guard var sourceId = news?.sourceId else {return}
        var avatarUrl: String = ""
        var sourceName: String = ""
        var postDate: Date = Date.distantPast
        guard sourceId != 0 else {return}
        if sourceId > 0 {
            guard let news = news,
                let sourceDB = try? Realm().objects(User.self).filter("id == %@", sourceId),
                let user = sourceDB.first
                else {return}
            avatarUrl = user.avatar
            sourceName = (user.first_name+" "+user.last_name)
            postDate = Date(timeIntervalSince1970: news.date)
        } else {
            sourceId = -sourceId
            guard let news = news,
                let sourceDB = try? Realm().objects(Group.self).filter("id == %@", sourceId),
                let group = sourceDB.first
                else {return}
            avatarUrl = group.avatar
            sourceName = group.name
            postDate = Date(timeIntervalSince1970: news.date)
        }
        avatar.kf.setImage(with: URL(string: avatarUrl))
        name.text = sourceName
        date.text = postDate.toString(dateFormat: "HH:mm dd-MM-yy")
    }
}
