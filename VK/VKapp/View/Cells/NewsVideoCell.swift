//
//  NewsVideoCell.swift
//  VKapp
//
//  Created by Юрий Султанов on 01.11.2019.
//  Copyright © 2019 Юрий Султанов. All rights reserved.
//

import UIKit
import WebKit

class NewsVideoCell: UITableViewCell {
    var webView: WKWebView = {
        let webView = WKWebView()
        webView.contentMode = .scaleAspectFit
        webView.allowsBackForwardNavigationGestures = false
        return webView
    }()
    
    private var height: CGFloat = .greatestFiniteMagnitude
    
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
        setupVideo()
        addSubview(webView)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupVideo()
    }
    
    private func setupVideo(){
        webView.frame = CGRect (x: 0, y: 0, width: bounds.width, height: height)
    }
    
    func configureVideoCell (with news: News){
        guard let video = news.videoAttachments.first else {return}
        self.height = (bounds.width * CGFloat(video.aspectRatio)).rounded(.up)
        let url = URL (string: video.player)
        let requestObj = URLRequest(url: url!)
        webView.load(requestObj)
    }

}
