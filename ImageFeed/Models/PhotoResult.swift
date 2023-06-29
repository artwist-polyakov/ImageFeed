//
//  PhotoResult.swift
//  ImageFeed
//
//  Created by Александр Поляков on 23.06.2023.
//

import Foundation

struct OnePhotoResult: Codable {
    let id: String
    let width: Int
    let height: Int
    let createdAt: String
    let description: String?
    let urls: UrlsResult
    let isLiked: Bool
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case width="width"
        case height="height"
        case description="description"
        case createdAt = "created_at"
        case urls = "urls"
        case isLiked = "liked_by_user"
    }
}

struct UrlsResult: Codable {
    let raw: String?
    let full: String?
    let regular: String?
    let small: String?
    let thumb: String?
}

