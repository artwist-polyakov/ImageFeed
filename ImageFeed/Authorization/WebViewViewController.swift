//
//  WebViewViewController.swift
//  ImageFeed
//
//  Created by Александр Поляков on 28.05.2023.
//

import UIKit
import WebKit

fileprivate let UnsplashAuthorizeURLString = "https://unsplash.com/oauth/authorize"

final class WebViewViewController: UIViewController {
    
    weak var delegate: WebViewViewControllerDelegate?

    @IBOutlet private weak var webView: WKWebView!
    
    @IBAction private func didTapBackButton(_ sender: Any) {
        delegate?.webViewViewControllerDidCancel(self)
    }
    
    
    override func viewDidLoad() {
        
        webView.navigationDelegate = self

        // документация тут https://unsplash.com/documentation/user-authentication-workflow
        // нас интересует фрагмент https://share.cleanshot.com/yMSRhPDtVgxzhnZ7xWfp
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

extension WebViewViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView,
                          decidePolicyFor navigationAction: WKNavigationAction,
                          decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        if let code = code (from: navigationAction) {
            //TODO: process code
            decisionHandler(.cancel)
        } else {
            decisionHandler(.allow)
        }
    }
    
    private func code (from navigationAction: WKNavigationAction) -> String? {
        if
            let url = navigationAction.request.url,
            let urlComponents = URLComponents(string: url.absoluteString),
            urlComponents.path == "/oauth/authorize/native",
            let items = urlComponents.queryItems,
            let codeItem = items.first(where: {$0.name == "code"}) {
            return codeItem.value
        } else {
            return nil
        }
    }
}
