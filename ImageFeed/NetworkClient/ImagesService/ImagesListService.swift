//
//  ImagesListService.swift
//  ImageFeed
//
//  Created by Александр Поляков on 23.06.2023.
//

import Foundation
final class ImagesListService {
    private static let BATCH_SIZE = 10
    static let shared = ImagesListService()

    private (set) var photos: [Photo] = []
    static let DidChangeNotification = Notification.Name(rawValue: "ImagesListServiceDidChange")
    private var lastLoadedPage: Int?
    private var task: URLSessionTask?
    private let urlSession = URLSession.shared
    
    
    func fetchPhotosNextPage() {
        let nextPage = 1 + (Int(photos.count) / ImagesListService.BATCH_SIZE)
        assert(Thread.isMainThread)
        if task != nil {
            print("Останавливаю выполнение, потому что запущена задача ImagesListService")
            task?.cancel()
        }
        let parameters:[String:String] = [
            "page":String(nextPage),
            "per_page":String(ImagesListService.BATCH_SIZE)
        ]
        var photosPageRequest: URLRequest {
            URLRequest.makeHTTPRequest(path: "/photos", httpMethod: "GET", needToken: true, parameters: parameters)
        }
        
        let task = urlSession.objectTask(for: photosPageRequest) { [weak self] (result: Result<PhotoResult, Error>) in
            
            DispatchQueue.main.async {
                
                guard let self = self else { print("тут гард"); return }
                switch result {
                case .success(let body):
                    self.photos += body.photoList.map {
                        Photo(id: $0.id,
                              size: CGSize(width: $0.width,height: $0.height),
                              createdAt: $0.createdAt,
                              welcomeDescription: $0.description,
                              thumbImageURL: $0.urls.thumb ?? "",
                              largeImageURL: $0.urls.full ?? "",
                              isLiked: $0.isLiked)
                    }
                    NotificationCenter.default.post(
                        name: ImagesListService.DidChangeNotification,
                        object: self,
                        userInfo: ["photos": self.photos])
                    self.task = nil
                case .failure(let error):
                    print(error)
                    self.task = nil
                }
            }
        }
    }
}