//
//  UserResult.swift
//  ImageFeed
//
//  Created by Александр Поляков on 14.06.2023.
//

import Foundation
struct UserResult: Codable {
    let profileImage: ProfileImage?
    enum CodingKeys: String, CodingKey {
        case profileImage = "profile_image"
    }
}

struct ProfileImage: Codable {
        let small: String?
        let medium: String?
        let large: String?
    }
