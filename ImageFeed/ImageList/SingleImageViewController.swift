//
//  SingleImageViewController.swift
//  ImageFeed
//
//  Created by Александр Поляков on 12.05.2023.
//

import UIKit
final class SingleImageViewController: UIViewController {
    var image: UIImage!
    @IBOutlet var bigSinglePicture: UIImageView!
    
    override func viewDidLoad() {
            super.viewDidLoad()
            bigSinglePicture.image = image
        }
}
