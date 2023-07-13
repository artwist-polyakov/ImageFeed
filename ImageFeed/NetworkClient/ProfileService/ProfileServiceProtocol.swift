//
//  ProfileServiceProtocol.swift
//  ImageFeed
//
//  Created by Александр Поляков on 13.07.2023.
//

import Foundation
public protocol ProfileServiceProtocol {
    var profile: Profile? { get }
    func fetchProfile(completion: @escaping(Result<Profile, Error>) -> ())
}


