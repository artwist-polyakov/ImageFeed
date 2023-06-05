//
//  OAuthTokenResponseBody.swift
//  ImageFeed
//
//  Created by Александр Поляков on 01.06.2023.
//

import Foundation
struct OAuthTokenResponseBody: Codable {
    let accessToken: String
    let tokenType: String
    let scope: String
    let createdAt: Int64
    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case tokenType = "token_type"
        case scope
        case createdAt = "created_at"
    }
}
