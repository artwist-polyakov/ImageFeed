//
//  Photo.swift
//  ImageFeed
//
//  Created by Александр Поляков on 23.06.2023.
//

import CoreFoundation
import CoreGraphics
import Foundation

struct Photo {
    let id: String
    let size: CGSize
    let createdAt: String
    let welcomeDescription: String?
    let thumbImageURL: String
    let largeImageURL: String
    let isLiked: Bool
} 
