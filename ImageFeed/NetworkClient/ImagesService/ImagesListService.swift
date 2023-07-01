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
    private var likeTask: URLSessionTask?
    private let urlSession = URLSession.shared
    
    func getCurreentBatchSize() -> Int {
        return ImagesListService.BATCH_SIZE
    }
    
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
        print("ImagesListService: запрашиваю изображения с параметрами: \(parameters)")
        let task = urlSession.objectTask(for: photosPageRequest) { [weak self] (result: Result<[OnePhotoResult], Error>) in
            print("ImagesListService запущена задача")
            DispatchQueue.main.async {
                
                guard let self = self else { print("ImagesListService тут гард"); return }
                switch result {
                case .success(let body):
                    print("ImagesListService: обновляю фотографии, текущая длина массива фото \(self.photos.count)")
                    self.photos += body.map {
                        Photo(id: $0.id,
                              size: CGSize(width: Double($0.width) ,height: Double($0.height)),
                              createdAt: $0.createdAt,
                              welcomeDescription: $0.description,
                              thumbImageURL: $0.urls.thumb ?? "",
                              largeImageURL: $0.urls.full ?? "",
                              isLiked: $0.isLiked)
                    }
                    print("ImagesListService: обновил фотографии, текущая длина массива фото \(self.photos.count)")
                    NotificationCenter.default.post(
                        name: ImagesListService.DidChangeNotification,
                        object: self,
                        userInfo: ["photos": self.photos])
                    self.task = nil
                case .failure(let error):
                    print("ImagesListService ОШИБКА \(error)")
                    self.task = nil
                }
            }
        }
        self.task = task
        task.resume()
    }
    
    func changeLike(
        photoId: String,
        hasLike: Bool,
        index: Int,
        _ completion: @escaping (Result<LikedPhoto, Error>) -> Void)
    {
        let httpMethod = hasLike ? "DELETE" : "POST"
        assert(Thread.isMainThread)
        if likeTask != nil {
            print("LikeService Останавливаю выполнение, потому что запущена задача ImagesListService Like")
            likeTask?.cancel()
        }
        print("LikeService - готовлю  запросы")
        var changeLikeRequest: URLRequest {
            URLRequest.makeHTTPRequest(
                path: "/photos/\(photoId)/like",
                httpMethod: httpMethod,
                needToken: true)
        }
        print("LikeService - готовлю  задачи")
        let task = urlSession.objectTask(for: changeLikeRequest) { [weak self] (result: Result<LikeUpdateResult, Error>) in
            print("LikeService ImagesListService Like запущена задача")
            UIBlockingProgressHUD.show()
            DispatchQueue.main.async {
                guard let self = self else { print("ImagesListService Like тут гард"); return }
                switch result {
                case .success(let body):
                    let likedPhoto = body.photo
                    print("LikeService ImagesListService Like: обновил лайк для \(likedPhoto.id)")
                    completion(.success(likedPhoto))
                    self.photos[index].isLiked = !hasLike
                    self.likeTask = nil
                    UIBlockingProgressHUD.dismiss()
                case .failure(let error):
                    print("LikeService ImagesListService Like ОШИБКА \(error)")
                    completion(.failure(error))
                    self.likeTask = nil
                    UIBlockingProgressHUD.dismiss()
                }
                
            }
            
        }
        self.likeTask = task
        task.resume()
        
    }
    
}
