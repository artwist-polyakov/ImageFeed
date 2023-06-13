//
//  OAuth2TokenStorage.swift
//  ImageFeed
//
//  Created by Александр Поляков on 01.06.2023.
//

import Foundation
class OAuth2TokenStorage {
    static let shared = OAuth2TokenStorage()
    
    private let tokenKey = "BearerToken"
    
    var token: String? {
        get {
            return UserDefaults.standard.string(forKey: tokenKey)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: tokenKey)
//            print("Установил токен: \(newValue ?? "NONE")")
        }
    }
}
