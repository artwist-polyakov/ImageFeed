//
//  ViewController.swift
//  ImageFeed
//
//  Created by Александр Поляков on 28.04.2023.
//

import UIKit
import Kingfisher
import ProgressHUD

class ImagesListViewController: UIViewController {
    @IBOutlet private weak var imagesTable: UITableView!
    private let photosName: [String] = Array(0..<20).map{ "\($0)" }
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        DispatchQueue.main.async {
            if self.currentPhotosCount == 0 {
                self.imagesListService.fetchPhotosNextPage()
            }
        }
        imagesTable.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)
        profileImageServiceObserver = NotificationCenter.default.addObserver(
            forName: ImagesListService.DidChangeNotification, // 3
            object: nil,                                        // 4
            queue: .main                                        // 5
        ) { [weak self] _ in
            guard let self = self else { return }
            self.updateTableViewAnimated()                                 // 6
        }
    }
    
    func updateTableViewAnimated() {
        let newCount = self.imagesListService.photos.count
        if self.currentPhotosCount != newCount {
            let previousCount = self.currentPhotosCount
            self.currentPhotosCount = newCount
            imagesTable.performBatchUpdates {
                let indexPaths = (previousCount..<newCount).map { i in
                    IndexPath(row: i, section: 0)
                }
                imagesTable.insertRows(at: indexPaths, with: .automatic)
            } completion: { _ in
                
            }
            
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowSingleImage" {
            if let viewController = segue.destination as? SingleImageViewController {
                if let indexPath = sender as? IndexPath {
                    let photo = imagesListService.photos[indexPath.row]
                    viewController.imageToLoad = photo
                }
            }
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
}

extension ImagesListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return imagesListService.photos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ImagesListCell.reuseIdentifier, for: indexPath)
        guard let imageListCell = cell as? ImagesListCell else {
            return UITableViewCell()
        }
        configCell(for: imageListCell, with: indexPath)
        return imageListCell
    }
}

extension ImagesListViewController {
    private func setLiked(
        to likeButton: UIButton,
        state: Bool
    ) {
        let picture = state ? UIImage(named: "LikeButtonOn") : UIImage(named: "LikeButtonOff")
        likeButton.setImage(picture, for: .normal)
    }
    
    func configCell(for cell: ImagesListCell, with indexPath: IndexPath) {
        cell.delegate = self
        let photo = imagesListService.photos[indexPath.row]
        let imageLink  = photo.thumbImageURL
        guard let url = URL(string: imageLink)
        else {return}
//        let indicator = ProgressHUDIndicator()
//        cell.picture.kf.indicatorType = .custom(indicator: indicator)
        
        let placeholderColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.5)
        let processor = RoundCornerImageProcessor(cornerRadius: 16)
        let options: KingfisherOptionsInfo = [
            .backgroundDecode,
            .onFailureImage(placeholderImage?.kf.image(withBlendMode: .normal, backgroundColor: placeholderColor)),
            .processor(processor)
        ]
        cell.picture.contentMode = .center
        cell.picture.kf.setImage(
            with:url,
            placeholder: placeholderImage,
            options: options,
            completionHandler:{ [weak self] result in
                guard self != nil else { return }
                switch result {
                case .success(let value):
                    // Загрузка изображения прошла успешно
                    print("Фотография загружена: \(value.source.url?.absoluteString ?? "")")
                    cell.picture.contentMode = .scaleAspectFill
                    self?.imagesTable.reloadRows(at: [indexPath], with: .automatic)
                case .failure(let error):
                    // Возникла ошибка при загрузке изображения
                    print("Фотография не загружена: \(error)")
                }
            })
        setLiked(to: cell.likeButton, state: photo.isLiked)
        guard let createdAt = photo.createdAt else {cell.dateLabel.text = ""; return}
        cell.dateLabel.text = dateFormatter.string(from: convertStringtoDate(unsplashDate: createdAt))
    }
    
}

extension ImagesListViewController: UITableViewDelegate {
    func tableView(
        _ tableView: UITableView,
        didSelectRowAt indexPath: IndexPath
    ) {
        performSegue(withIdentifier: "ShowSingleImage", sender: indexPath)
    }
    
    func tableView(
        _ tableView: UITableView,
        heightForRowAt indexPath: IndexPath
    ) -> CGFloat {
        guard indexPath.row < imagesListService.photos.count else {
                return 0
            }
        let photo = imagesListService.photos[indexPath.row]
        let imageInsets = UIEdgeInsets(top: 4, left: 16, bottom: 4, right: 16)
        let imageViewWidth = tableView.bounds.width - imageInsets.left - imageInsets.right
        let imageWidth = photo.size.width
        let scale = imageViewWidth / imageWidth
        let cellHeight = photo.size.height * scale + imageInsets.top + imageInsets.bottom
        return cellHeight
    }
    
    func tableView(
      _ tableView: UITableView,
      willDisplay cell: UITableViewCell,
      forRowAt indexPath: IndexPath
    ) {
        if indexPath.row + 1 >= currentPhotosCount {
            imagesListService.fetchPhotosNextPage()
        }
    }

}

extension ImagesListViewController: ImagesListCellDelegate {
    func imageListCellDidTapLike(_ cell: ImagesListCell) {
        guard let indexPath = imagesTable.indexPath(for: cell) else { return }
        let photo = imagesListService.photos[indexPath.row]
        imagesListService.changeLike(photoId: photo.id, hasLike: photo.isLiked, index: indexPath.row) {result in
            switch result {
            case .success:
                print("LikeService обновил лайк в \(indexPath)")
                self.imagesTable.reloadData()
            case .failure:
                print("Что-то не получилось поставить лайк в \(indexPath)")
            }
     
        }
    }
}
