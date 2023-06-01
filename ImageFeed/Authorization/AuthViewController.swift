//
//  AuthViewController.swift
//  ImageFeed
//
//  Created by Александр Поляков on 28.05.2023.
//

import UIKit
class AuthViewController: UIViewController {
    
    let segueIdentifier = "ShowWebView"
  
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == segueIdentifier {
            // Получение следующего View Controller
            guard let webViewViewController = segue.destination as? WebViewViewController else {
                fatalError("Failed to prepare for \(segueIdentifier)")}
            webViewViewController.delegate = self}
        else {
            super.prepare(for: segue, sender: sender)
        }
    }
}

extension AuthViewController: WebViewViewControllerDelegate {
    func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String) {
        OAuth2Service.shared.fetchOAuthToken(code) {result in
            switch result {
            case .success(let authToken):
                OAuth2TokenStorage.shared.token = authToken
                print("Access token saved")
            case .failure(let error):
                print("Failed to fetch access token: \(error)")
            }
        }
    }

    func webViewViewControllerDidCancel(_ vc: WebViewViewController) {
        dismiss(animated: true)
    }
}
