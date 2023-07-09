//
//  ProfileImageService.swift
//  ImageFeed
//
//  Created by Александр Поляков on 14.06.2023.
//

import Foundation
final class ProfileImageService {
    static let shared = ProfileImageService()
    private let urlSession = URLSession.shared
    private var task: URLSessionTask?
    private(set) var avatarURL: String?
    static let DidChangeNotification = Notification.Name(rawValue: "ProfileImageProviderDidChange")
    
    func fetchProfileImageURL(
        username: String,
        completion: @escaping (Result<String?, Error>) -> Void
    ) {
        assert(Thread.isMainThread)
        
        if task != nil {
            print("Останавливаю выполнение, потому что запущена задача fetchProfileImageURL")
            task?.cancel()
        }
        
        var profilePhotoRequest: URLRequest {
            URLRequest.makeHTTPRequest(path: "/users/\(username)", httpMethod: "GET", needToken: true)
        }
        let task = urlSession.objectTask(for: profilePhotoRequest) { [weak self] (result: Result<UserResult, Error>) in
            DispatchQueue.main.async {
                
                guard let self = self else { return }
                switch result {
                case .success(let body):
                    self.avatarURL = body.profileImage?.medium
                    completion(.success(self.avatarURL))
                    NotificationCenter.default.post(
                        name: ProfileImageService.DidChangeNotification,
                        object: self,
                        userInfo: ["URL": self.avatarURL ?? ""])
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
