//
//  ProfileService.swift
//  ImageFeed
//
//  Created by Александр Поляков on 11.06.2023.
//

import Foundation

final class ProfileService {
    private let urlSession = URLSession.shared
    private var task: URLSessionTask?
    var profile: Profile?
    
    func fetchProfile(
        _ token: String,
        completion: @escaping (Result<Profile, Error>) -> Void
    ) {
        assert(Thread.isMainThread)
        
        if task != nil {
            task?.cancel()
        }
        
        var selfProfileRequest: URLRequest {
            URLRequest.makeHTTPRequest(path: "/me", httpMethod: "GET", needToken: true)
        }
        
        let task = object(for: selfProfileRequest) { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else { return }
                switch result {
                case .success(let body):
                    let profile = Profile(username: body.username, name: body.firstName + body.lastName, loginName: "@"+body.username, bio: body.bio)
                    completion(.success(profile))
                    self.task = nil
                    self.profile = profile
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
        self.task = task
        task.resume()
    }
}

extension ProfileService {
    private func object(
        for request: URLRequest,
        completion: @escaping (Result<ProfileResult, Error>) -> Void
    ) -> URLSessionTask {
        let decoder = JSONDecoder()
        return urlSession.data(for: request) { (result: Result<Data, Error>) in
        switch result {
            case .success(let data):
                do {
                    let object = try decoder.decode(
                        ProfileResult.self,
                        from: data
                        )
                    completion(.success(object))
                    } catch {
                        completion(.failure(error))
                    }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}


