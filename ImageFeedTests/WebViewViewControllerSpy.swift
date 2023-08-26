//
//  WebViewViewControllerSpy.swift
//  ImageFeedTests
//
//  Created by Александр Поляков on 10.07.2023.
//

import Foundation
import UIKit
import ImageFeed

final class WebViewViewControllerSpy: WebViewViewControllerProtocol {
    var presenter: ImageFeed.WebViewPresenterProtocol?
    var didRequestLoaded: Bool  = false

    func load(request: URLRequest) {
        didRequestLoaded = true
    }
    
    func setProgressValue(_ newValue: Float) {
    }
    
    func setProgressHidden(_ isHidden: Bool) {
    }
    
    
    
    
}
