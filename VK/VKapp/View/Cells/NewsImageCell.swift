//
//  NewsContentImage.swift
//  VKapp
//
//  Created by Юрий Султанов on 17.09.2019.
//  Copyright © 2019 Юрий Султанов. All rights reserved.
//

import UIKit
import Kingfisher

class NewsImageCell: UITableViewCell {
    var newsImage: UIImageView!
    private let height: CGFloat = 150
    private let offset: CGFloat = 5
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = .clear
        self.selectionStyle = .none
        setupSubviews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupSubviews()
    }
    
    private func setupSubviews(){
        addSubview(newsImage)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupImage()
    }
    
    private func setupImage(){
        let size = CGSize (width: bounds.width, height: height)
        let origin = CGPoint (x: (offset), y: (bounds.height - height)/2)
        newsImage.frame = CGRect (origin: origin, size: size)
    }
    
    func configureImageCell (with news: News){
        guard let image = news.photoAttachments.first?.urlSmallPhoto else {return}
        newsImage.kf.setImage(with: URL(string: image))
    }
    
}
