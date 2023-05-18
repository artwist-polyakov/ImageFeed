//
//  GradientUnderDate.swift
//  ImageFeed
//
//  Created by Александр Поляков on 16.05.2023.
//

import UIKit

class GradientUnderDate: UIView {
    override class var layerClass: AnyClass {
        return CAGradientLayer.self
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupGradient()
    }
    
    private func setupGradient() {
        guard let gradientLayer = layer as? CAGradientLayer else {
            return
        }
        let blackColor = UIColor.black.withAlphaComponent(0.5).cgColor
        let transparentColor = UIColor.clear.cgColor
        gradientLayer.colors = [transparentColor, blackColor, blackColor, transparentColor]
        gradientLayer.locations = [0, 0.45, 0.55, 1]
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1)
        layer.cornerRadius = 16
        layer.masksToBounds = true
    }
}

