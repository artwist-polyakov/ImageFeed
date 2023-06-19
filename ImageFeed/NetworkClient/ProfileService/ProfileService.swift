//
//  ProfileService.swift
//  ImageFeed
//
//  Created by Александр Поляков on 11.06.2023.
//

import Foundation

final class ProfileService {
    static let shared = ProfileService()
    
    private let urlSession = URLSession.shared
    private var task: URLSessionTask?
    private(set) var profile: Profile?
    
    func fetchProfile(
        completion: @escaping (Result<Profile, Error>) -> Void
    ) {
        assert(Thread.isMainThread)
        if task != nil {
            print("Таск == нил")
            task?.cancel()
        }
        
        var selfProfileRequest: URLRequest {
            URLRequest.makeHTTPRequest(path: "/me", httpMethod: "GET", needToken: true)
        }
        let task = urlSession.objectTask(for: selfProfileRequest) { [weak self] (result: Result<ProfileResult, Error>) in
            
            DispatchQueue.main.async {

                guard let self = self else { print("тут гард"); return }
                switch result {
                case .success(let body):
                    let profile = Profile(username: body.username, name: "\(body.firstName ?? "") \(body.lastName ?? "")", loginName: "@\(body.username)", bio: body.bio ?? "")
                    self.profile = profile
                    completion(.success(profile))
                    self.task = nil
                case .failure(let error):
                    print(error)
                    completion(.failure(error))
                    self.task = nil
                }
            }
        }
        
        self.task = task
        task.resume()
    }
}


