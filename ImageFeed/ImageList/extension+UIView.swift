//
//  extension+UIView.swift
//  ImageFeed
//
//  Created by Александр Поляков on 18.07.2023.
//

import Foundation
import UIKit

extension UIView {
    func addGradientAnimation() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [
                    UIColor(red: 0.682, green: 0.686, blue: 0.706, alpha: 1).cgColor,
                    UIColor(red: 0.431, green: 0.433, blue: 0.453, alpha: 1).cgColor,
                    UIColor(red: 0.682, green: 0.686, blue: 0.706, alpha: 1).cgColor
                ]
        gradientLayer.locations = [-0.01, 0.25, 0.5]
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.0)
        gradientLayer.frame = bounds
        gradientLayer.cornerRadius = 20
        layer.addSublayer(gradientLayer)
        
        let animation = CAKeyframeAnimation(keyPath: "locations")
        animation.values = [[0.0, 0.0, 0.25], [0.0, 0.5, 1.0], [0.75, 1.0, 1.0]]
        animation.keyTimes = [0.0, 0.5, 1.0]
        animation.timingFunctions = [
            CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeIn),
            CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut)
        ]
        animation.repeatCount = .infinity
        animation.duration = 2.0
        gradientLayer.add(animation, forKey: "locationsChange")
    }
    
    func removeGradientAnimation() {
        layer.sublayers?.forEach { layer in
            if layer is CAGradientLayer {
                layer.removeFromSuperlayer()
            }
        }
    }
}
