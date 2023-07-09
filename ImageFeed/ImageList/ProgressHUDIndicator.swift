//
//  ProgressHUDIndicator.swift
//  ImageFeed
//
//  Created by Александр Поляков on 29.06.2023.
//

import UIKit
import Kingfisher
import ProgressHUD

class ProgressHUDIndicator: Indicator {
    var view: Kingfisher.IndicatorView
    private var progressHUD: ProgressHUD?

    init() {
        view = Kingfisher.IndicatorView() // Инициализируем свойство view
    }

    func startAnimatingView() {
        progressHUD = ProgressHUD()
        ProgressHUD.show()
    }

    func stopAnimatingView() {
        ProgressHUD.dismiss()
        progressHUD = nil
    }
}
