//
//  WebViewViewController.swift
//  ImageFeed
//
//  Created by Александр Поляков on 28.05.2023.
//

import UIKit
import WebKit

class WebViewViewController: UIViewController {

    @IBOutlet private weak var webView: WKWebView!
    
    @IBAction private func didTapBackButton(_ sender: Any) {
    }
    
    override func viewDidLoad() {
        // документация тут https://unsplash.com/documentation/user-authentication-workflow
        // нас интересует фрагмент https://share.cleanshot.com/yMSRhPDtVgxzhnZ7xWfp
        let UnsplashAuthorizeURLString: String = "https://unsplash.com/oauth/authorize"
        var urlComponents = URLComponents(string: UnsplashAuthorizeURLString)!
        urlComponents.queryItems = [
        URLQueryItem(name: "client_id", value: AccessKey),
        URLQueryItem(name: "redirect_uri", value: RedirectURI),
        URLQueryItem(name: "response_type", value: "code"),
        URLQueryItem(name: "scope", value: AccessScope)
        ]
        let url = urlComponents.url!
        let request = URLRequest(url: url)
        webView.load(request)
    }
    
}
