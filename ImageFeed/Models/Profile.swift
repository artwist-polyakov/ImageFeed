//
//  Profile.swift
//  ImageFeed
//
//  Created by Александр Поляков on 13.06.2023.
//

public struct Profile {
    public let username: String
    public let name: String?
    public let loginName: String
    public let bio: String?
    
    public init(username: String, name: String?, loginName: String, bio: String?) {
            self.username = username
            self.name = name
            self.loginName = loginName
            self.bio = bio
        }
}
