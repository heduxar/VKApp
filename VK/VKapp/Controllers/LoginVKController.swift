//
//  LoginVK.swift
//  VKapp
//
//  Created by Юрий Султанов on 15.08.2019.
//  Copyright © 2019 Юрий Султанов. All rights reserved.
//

import UIKit
import WebKit

class LoginVKController: UIViewController {
    
    @IBOutlet weak var webView: WKWebView! {
        didSet {
            webView.navigationDelegate = self
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var components = URLComponents()
        components.scheme = "https"
        components.host = "oauth.vk.com"
        components.path = "/authorize"
        components.queryItems = [
            URLQueryItem(name: "client_id", value: "7099659"),
            URLQueryItem(name: "scope", value: "336918"),
            URLQueryItem(name: "display", value: "mobile"),
            URLQueryItem(name: "redirect_uri", value: "https://oauth.vk.com/blank.html"),
            URLQueryItem(name: "response_type", value: "token"),
            URLQueryItem(name: "v", value: "5.101")
        ]
        
        let request = URLRequest(url: components.url!)
        webView.load(request)
    }
    
}

extension LoginVKController: WKNavigationDelegate  {
    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        guard let url = navigationResponse.response.url,
            url.path == "/blank.html",
            let fragment = url.fragment else { decisionHandler(.allow); return }
        
        let params = fragment
            .components(separatedBy: "&")
            .map { $0.components(separatedBy: "=") }
            .reduce([String: String]()) { result, param in
                var dict = result
                let key = param[0]
                let value = param[1]
                dict[key] = value
                return dict
        }
        
        print(params)
        
        guard let token = params["access_token"],
            let userIdString = params["user_id"],
            let userIdInt = Int(userIdString) else {
                decisionHandler(.allow)
                return
        }
        
        Session.session.token = token
        Session.session.userID = userIdInt
        performSegue(withIdentifier:"LoginTrueSegue", sender: Any?.self)
        
        decisionHandler(.cancel)
    }
}
