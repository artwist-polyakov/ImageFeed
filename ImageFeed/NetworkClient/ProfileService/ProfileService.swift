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
    var avatarLink: URL?
    
    func fetchProfile(
        _ token: String,
        completion: @escaping (Result<Profile, Error>) -> Void
    ) {
        print("До ассерта")
        assert(Thread.isMainThread)
        print("После ассерта")
        if task != nil {
            print("Таск == нил")
            task?.cancel()
        }
        
        var selfProfileRequest: URLRequest {
            URLRequest.makeHTTPRequest(path: "/me", httpMethod: "GET", needToken: true)
        }
        let task = object(for: selfProfileRequest) { [weak self] result in
            DispatchQueue.main.async {
                print("Я тута")
                print(result)
                guard let self = self else { print("тут гард"); return }
                switch result {
                case .success(let body):
                    print("Тут успех")
                    let profile = Profile(username: body.username, name: "\(body.firstName ?? "") \(body.lastName ?? "")", loginName: "@\(body.username)", bio: body.bio ?? "")
                    self.profile = profile
                    var imageProfileRequest: URLRequest {
                        URLRequest.makeHTTPRequest(path: "/users/\(body.username)", httpMethod: "GET", needToken: true)
                        
                    }
                    let decoder = JSONDecoder()
                    
                    
                    
                    completion(.success(profile))
                    self.task = nil
                    print("Вот какой профиль \(String(describing: self.profile))")
                case .failure(let error):
                    print("Тут не успех")
                    completion(.failure(error))
                    self.task = nil
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
            let response = result.flatMap { data -> Result<ProfileResult, Error> in
                Result { try decoder.decode(ProfileResult.self, from: data) }
            }
            completion(response)
        }
    }
}


