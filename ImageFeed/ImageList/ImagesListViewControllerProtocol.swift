//
//  ImagesListViewControllerProtocol.swift
//  ImageFeed
//
//  Created by Александр Поляков on 13.07.2023.
//

import Foundation
import UIKit
protocol ImagesListViewControllerProtocol {
    func imagesTableGetter() -> UITableView
    func imagesTableSetter(push: UITableView)
}
