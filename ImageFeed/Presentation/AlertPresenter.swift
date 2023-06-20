//
//  AlertPresenter.swift
//  ImageFeed
//
//  Created by Александр Поляков on 16.06.2023.
//

import UIKit
final class AlertPresenter {
    
    
    func show(in vc: UIViewController, model: AlertModel) {
        let alert = UIAlertController(
            title: model.title, message: model.message, preferredStyle: .alert)
        let action = UIAlertAction(title: model.buttonText, style: .default) {_ in
            model.completion()
        }
        
        alert.addAction(action)
        vc.present(alert, animated: true, completion: nil)
    }
}
