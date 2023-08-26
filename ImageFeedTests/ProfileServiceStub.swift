//
//  ProfileServiceStub.swift
//  ImageFeedTests
//
//  Created by Александр Поляков on 13.07.2023.
//
import ImageFeed
import Foundation

final class ProfileServiceStub: ProfileServiceProtocol {
    static let shared = ProfileServiceStub()
    private(set) var profile: Profile?
    
    func fetchProfile(completion: @escaping (Result<ImageFeed.Profile, Error>) -> ()) {
        self.profile = Profile(username: "UserName",
                               name: "Name",
                               loginName: "@Login",
                               bio: "someBio")
    }
    
    
    
    
}
