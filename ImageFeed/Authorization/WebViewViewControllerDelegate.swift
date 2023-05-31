//
//  WebViewViewControllerDelegate.swift
//  ImageFeed
//
//  Created by Александр Поляков on 31.05.2023.
//

protocol WebViewViewControllerDelegate: AnyObject {
    func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String)
    func webViewViewControllerDidCancel(_ vc: WebViewViewController)
}
