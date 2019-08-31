//
//  MainTableCell.swift
//  VKapp
//
//  Created by Юрий Султанов on 18.07.2019.
//  Copyright © 2019 Юрий Султанов. All rights reserved.
//

import UIKit
import Kingfisher

class MainTableCell: UITableViewCell {
    @IBOutlet var avatar: AvatarImage!
    @IBOutlet var name: UILabel!
    @IBOutlet var backForShadow: AvatarBackShadow!
    
    public func configureGroup(with group: Group?) {
        guard let group = group else {return}
        name.text = group.name
        avatar.kf.setImage(with: URL(string: group.avatar))
    }
    public func configureUser(with user: User?){
        guard let user = user else {return}
        name.text = user.first_name + " " + user.last_name
        avatar.kf.setImage(with: URL(string: user.avatar))
    }
}
