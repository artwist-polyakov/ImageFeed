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
    let placeholderImage = UIImage(named: "placeholder_cell")
    private let imagesListService = ImagesListService.shared
    private var currentPhotosCount: Int = 0
    private var profileImageServiceObserver: NSObjectProtocol?
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        return formatter
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        DispatchQueue.main.async {
            if self.currentPhotosCount == 0 {
                self.imagesListService.fetchPhotosNextPage()
                self.currentPhotosCount += self.imagesListService.getCurreentBatchSize()
            }
        }
        imagesTable.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)
        profileImageServiceObserver = NotificationCenter.default.addObserver(
            forName: ImagesListService.DidChangeNotification, // 3
            object: nil,                                        // 4
            queue: .main                                        // 5
        ) { [weak self] _ in
            guard let self = self else { return }
            self.imagesTable.reloadData()
            self.updateTableViewAnimated()                                 // 6
        }
    }
    
    func updateTableViewAnimated() {
        let newCount = imagesListService.photos.count
        if currentPhotosCount != newCount {
            self.currentPhotosCount = newCount
            imagesTable.performBatchUpdates {
                let indexPaths = (currentPhotosCount..<newCount).map { i in
                    IndexPath(row: i, section: 0)
                }
                print("updateTableViewAnimated: \(indexPaths)")
                imagesTable.insertRows(at: indexPaths, with: .automatic)
            } completion: { _ in
                
            }
            
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowSingleImage" {
            if let viewController = segue.destination as? SingleImageViewController {
                if let indexPath = sender as? IndexPath {
                    let image = UIImage(named: photosName[indexPath.row])
                    viewController.image = image
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
        print("Мы в тейблвью, заправшиваем ячейку")
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
        print("Мы в configCell")
        let imageLink  = imagesListService.photos[indexPath.row].thumbImageURL
        guard let url = URL(string: imageLink)
        else {return}
        let isEvenIndex = indexPath.row % 2 == 0
//        cell.picture.kf.indicatorType = .custom(indicator: ProgressHUD.self as! Indicator)
        cell.picture.kf.setImage(
            with:url,
            placeholder: placeholderImage,
            options: nil,
            completionHandler:{ [weak self] result in
                guard self != nil else { return }
                
                switch result {
                case .success(let value):
                    // Загрузка изображения прошла успешно
                    print("Фотокарточка загружена: \(value.source.url?.absoluteString ?? "")")
                    self?.imagesTable.reloadRows(at: [indexPath], with: .automatic)
                case .failure(let error):
                    // Возникла ошибка при загрузке изображения
                    print("Фотокарточка не загружена: \(error)")
                }
            })
        cell.dateLabel.text = dateFormatter.string(from: Date())
        setLiked(to: cell.likeButton, state: isEvenIndex)
        //        cell.likeButton.setImage(isEvenIndex ? UIImage(named: "LikeButtonOn") : UIImage(named: "LikeButtonOff"), for: .normal )
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
        print("counter = \(indexPath.row)")
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
