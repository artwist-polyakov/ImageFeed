//
//  LikeUpdateResult.swift
//  ImageFeed
//
//  Created by Александр Поляков on 30.06.2023.
//

import Foundation

struct LikeUpdateResult: Codable {
    let photo: LikedPhoto
}

struct LikedPhoto: Codable {
    let id: String
}


