//
//  NewsCell.swift
//  VKapp
//
//  Created by Юрий Султанов on 27.07.2019.
//  Copyright © 2019 Юрий Султанов. All rights reserved.
//

import UIKit

class NewsCell: UITableViewCell {
    @IBOutlet var avatar: UIImageView!
    @IBOutlet var name: UILabel!
    @IBOutlet var newsText: UITextView!
    @IBOutlet var stackOfImages: UIStackView!
    @IBOutlet var likeButton: UIButton!
    @IBOutlet var likesCounter: UILabel!
    
    private var likeState = false
    @IBAction private func like() {
        guard var curLikes = Int(likesCounter.text!) else {preconditionFailure("Can't load current likes")}
        if !likeState {
            //            likeButton.setImage(UIImage(named: "heart_filled"), for: UIControl.State.normal)
            UIView.transition(with: likeButton, duration: 0.3, options: .transitionFlipFromTop, animations: {
                self.likeButton.setImage(UIImage(named: "heart_filled"), for: .normal)
            }, completion: nil)
            curLikes += 1
            likeState.toggle()
            likesCounter.text = String(curLikes)
        } else {
            //            likeButton.setImage(UIImage(named: "heart_empty"), for: UIControl.State.normal)
            UIView.transition(with: likeButton, duration: 0.3, options: .transitionFlipFromBottom, animations: {
                self.likeButton.setImage(UIImage(named: "heart_empty"), for: .normal)
            }, completion: nil)
            curLikes -= 1
            likeState.toggle()
            likesCounter.text = String(curLikes)
        }
    }
    @IBOutlet var repostButton: UIButton!
    @IBOutlet var repostCounter: UILabel!
    private var repostState = false
    @IBAction private func repost(){
        guard var curReposts = Int(repostCounter.text!) else {preconditionFailure("Can't load curret reposts")}
        if !repostState {
            curReposts += 1
            repostState.toggle()
            repostCounter.text = String(curReposts)
        } else {
            curReposts -= 1
            repostState.toggle()
            repostCounter.text = String(curReposts)
        }
    }
    
    @IBOutlet var commentsButton: UIButton!
    @IBOutlet var commentsCounter: UILabel!
    @IBOutlet var viewCounter: UILabel!
}

