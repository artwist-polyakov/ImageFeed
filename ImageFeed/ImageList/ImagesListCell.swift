//
//  ImagesListCell.swift
//  ImageFeed
//
//  Created by Александр Поляков on 30.04.2023.
//

import UIKit

final class ImagesListCell: UITableViewCell {
    static let reuseIdentifier = "ImagesListCell"
    @IBOutlet var cellImage: UIImageView!
    
    @IBOutlet var cellLikeButton: UIButton!
    
    @IBOutlet var cellDateLabel: UILabel!
}
