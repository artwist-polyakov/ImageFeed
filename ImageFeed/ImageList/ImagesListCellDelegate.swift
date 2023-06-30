//
//  ImagesListCellDelegate.swift
//  ImageFeed
//
//  Created by Александр Поляков on 30.06.2023.
//

protocol ImagesListCellDelegate: AnyObject {
    func imageListCellDidTapLike(_ cell: ImagesListCell)
}
