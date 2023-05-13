//
//  SingleImageViewController.swift
//  ImageFeed
//
//  Created by Александр Поляков on 12.05.2023.
//

import UIKit
final class SingleImageViewController: UIViewController {
    var image: UIImage! {
        didSet {
            guard isViewLoaded else { return }
            bigSinglePicture.image = image
        }
    }
    @IBOutlet var bigSinglePicture: UIImageView!
    
    override func viewDidLoad() {
            super.viewDidLoad()
            bigSinglePicture.image = image
        }
    @IBAction private func didTabBackButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
