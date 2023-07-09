//
//  ImagesListCell.swift
//  ImageFeed
//
//  Created by Александр Поляков on 30.04.2023.
//

import UIKit

final class ImagesListCell: UITableViewCell {
    static let reuseIdentifier = "ImagesListCell"
    weak var delegate: ImagesListCellDelegate? 
    @IBOutlet weak var picture: UIImageView!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBAction func likeButtonClicked() {
        delegate?.imageListCellDidTapLike(self)
    }
    
    override func prepareForReuse() {
            super.prepareForReuse()
            // Отменяем загрузку, чтобы избежать багов при переиспользовании ячеек
            picture.kf.cancelDownloadTask()
        }
    
    
    
}
