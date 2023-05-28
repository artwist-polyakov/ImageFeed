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
            if let webViewViewController = segue.destination as? WebViewViewController {
                // Установка значения в свойство segueIdentifier следующего View Controller
               
            }
        }
    }

    
}
