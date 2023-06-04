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

    @IBOutlet private var progressView: UIProgressView!
    @IBOutlet private weak var webView: WKWebView!
    
    @IBAction private func didTapBackButton(_ sender: Any) {
        delegate?.webViewViewControllerDidCancel(self)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        webView.addObserver(
            self,
            forKeyPath: #keyPath(WKWebView.estimatedProgress),
            options: .new,
            context: nil)
    }
    
    override func viewDidLoad() {
//        UserDefaults.standard.removeObject(forKey: "BearerToken")
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
    
    
    override func viewDidDisappear(_ animated: Bool) {
        webView.removeObserver(self, forKeyPath:
        #keyPath(WKWebView.estimatedProgress), context: nil)
    }
    
    override func observeValue(
        forKeyPath keyPath: String?,
        of object: Any?,
        change: [NSKeyValueChangeKey : Any]?,
        context: UnsafeMutableRawPointer?
    ) {
        if keyPath == #keyPath(WKWebView.estimatedProgress) {
            updateProgress()
        } else {
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
        }
    }

    private func updateProgress() {
        progressView.progress = Float(webView.estimatedProgress)
        progressView.isHidden = fabs(webView.estimatedProgress - 1.0) <= 0.0001
    }
    
}

extension WebViewViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
            if let code = code(from: navigationAction) {
                // Вызываем метод делегата для передачи кода аутентификации
                delegate?.webViewViewController(self, didAuthenticateWithCode: code)
                decisionHandler(.cancel)
                self.dismiss(animated: true, completion: nil)
                
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
