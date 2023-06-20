//
//  OAuth2TokenStorage.swift
//  ImageFeed
//
//  Created by Александр Поляков on 01.06.2023.
//
import SwiftKeychainWrapper

class OAuth2TokenStorage {
    static let shared = OAuth2TokenStorage()
    private let tokenKey = "BearerToken"
    var token: String? {
        get {
            let token = KeychainWrapper.standard.string(forKey: tokenKey)
            guard let token = token else {return nil}
            return token
        }
        set {
            guard let newValue = newValue else { return }
            let isSuccess = KeychainWrapper.standard.set(newValue, forKey: tokenKey)
            if !isSuccess {
                print("Невозможно записать токен")
            }
        }
    }
    
    func removeToken() {
        let isSuccess = KeychainWrapper.standard.removeObject(forKey: tokenKey)
        if !isSuccess {
            print("Не удалось удалить токен")
        }
    }
}
