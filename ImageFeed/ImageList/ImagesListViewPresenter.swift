//
//  ImagesListViewPresenter.swift
//  ImageFeed
//
//  Created by Александр Поляков on 13.07.2023.
//

import Foundation
import UIKit
final class ImagesListViewPresenter: ImageListViewPresenterProtocol {
    var view: ImagesListViewController?
    let placeholderImage = UIImage(named: "stub")
    private let imagesListService = ImagesListService.shared
    private var currentPhotosCount: Int = 0
    private var profileImageServiceObserver: NSObjectProtocol?
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter
    }()
    
    
    
    func convertStringtoDate(unsplashDate: String) -> Date {
        let dateFormatter = ISO8601DateFormatter()
        let date = dateFormatter.date(from: unsplashDate)
        if let date = date {
            return date
        } else {
            return Date()
        }
    }
    
    func viewDidLoad() {
        DispatchQueue.main.async {
            if self.currentPhotosCount == 0 {
                self.imagesListService.fetchPhotosNextPage()
            }
        }
        profileImageServiceObserver = NotificationCenter.default.addObserver(
            forName: ImagesListService.DidChangeNotification,
            object: nil,
            queue: .main                                     
        ) { [weak self] _ in
            guard let self = self else { return }
            self.view?.updateTableViewAnimated()
        }
    }
    
}
