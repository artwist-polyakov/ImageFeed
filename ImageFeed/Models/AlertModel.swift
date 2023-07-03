//
//  AlertModel.swift
//  ImageFeed
//
//  Created by Александр Поляков on 16.06.2023.
//

import Foundation
struct AlertModel {
    var title: String
    var message: String
    var primaryButtonText: String
    var primaryButtonCompletion: (() -> ())
    var secondaryButtonText: String?
    var secondaryButtonCompletion: (() -> ())? 
}

