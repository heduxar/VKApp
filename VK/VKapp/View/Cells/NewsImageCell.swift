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

    var newsImage: UIImageView = {
        let newsImage = UIImageView()
        newsImage.contentMode = .scaleAspectFit
        newsImage.kf.indicatorType = .activity
        return newsImage
    }()
    
    private var height: CGFloat = .greatestFiniteMagnitude
    private let offset: CGFloat = 3
    
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
        setupImage()
        addSubview(newsImage)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupImage()
    }
    
    private func setupImage(){
        newsImage.frame = CGRect (x: offset, y: offset, width: bounds.width-(offset*2), height: height-(offset*2))
    }
    
    func configureImageCell (with news: News){
        if let image = news.photoAttachments.first{
            self.height = (bounds.width * CGFloat(image.aspectRatio)).rounded(.up)
            newsImage.kf.setImage(with: URL(string: image.urlPhotoX))
        } else if news.gifUrl != "" {
            self.height = (bounds.width * CGFloat(news.gifAspectRatio)).rounded(.up)
            newsImage.kf.setImage(with: URL(string: news.gifUrl))
        }
    }
}

//extension UIStackView {
//    func removeAllArrangedSubviews() {
//        let removedSubviews = arrangedSubviews.reduce([]) { (allSubviews, subview) -> [UIView] in
//            self.removeArrangedSubview(subview)
//            return allSubviews + [subview]
//        }
//        // Deactivate all constraints
//        NSLayoutConstraint.deactivate(removedSubviews.flatMap({ $0.constraints }))
//        // Remove the views from self
//        removedSubviews.forEach({ $0.removeFromSuperview() })
//    }
//}







//    let scrollView = UIScrollView()
//    internal let stackView: UIStackView = {
//        let stack = UIStackView()
//        stack.axis = .horizontal
//        stack.spacing = 1
//        return stack
//    }()

//    override init(frame: CGRect) {
//        super.init(frame: frame)
//
//        addSubview(scrollView)
//        scrollView.addSubview(stackView)
