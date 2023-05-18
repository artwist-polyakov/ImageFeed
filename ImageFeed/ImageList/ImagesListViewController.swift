//
//  ViewController.swift
//  ImageFeed
//
//  Created by Александр Поляков on 28.04.2023.
//

import UIKit
class ImagesListViewController: UIViewController {
    @IBOutlet private weak var imagesTable: UITableView!
    private let photosName: [String] = Array(0..<20).map{ "\($0)" }
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        return formatter
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        imagesTable.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)
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
        return photosName.count
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
    private func setLiked(to likeButton: UIButton, state: Bool) {
        let picture = state ? UIImage(named: "LikeButtonOn") : UIImage(named: "LikeButtonOff")
        likeButton.setImage(picture, for: .normal)
    }
    
    func configCell(for cell: ImagesListCell, with indexPath: IndexPath) {
        guard let image  = UIImage(named: photosName[indexPath.row]) else {
            return
        }
        let isEvenIndex = indexPath.row % 2 == 0
        cell.picture.image = image
        cell.dateLabel.text = dateFormatter.string(from: Date())
        setLiked(to: cell.likeButton, state: isEvenIndex)
        //        cell.likeButton.setImage(isEvenIndex ? UIImage(named: "LikeButtonOn") : UIImage(named: "LikeButtonOff"), for: .normal )
    }
}

extension ImagesListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "ShowSingleImage", sender: indexPath)
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let image = UIImage(named: photosName[indexPath.row]) else {
            return 0
        }
        let imageInsets = UIEdgeInsets(top: 4, left: 16, bottom: 4, right: 16)
        let imageViewWidth = tableView.bounds.width - imageInsets.left - imageInsets.right
        let imageWidth = image.size.width
        let scale = imageViewWidth / imageWidth
        let cellHeight = image.size.height*scale + imageInsets.top + imageInsets.bottom
        return cellHeight
    }
}
