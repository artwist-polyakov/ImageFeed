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
    
    @IBOutlet var scrollView: UIScrollView!
    let screenSize = UIScreen.main.bounds.size
    
    
    
    override func viewDidLoad() {
        
            super.viewDidLoad()
            scrollView.minimumZoomScale = 0.1
            scrollView.maximumZoomScale = 1.25
            bigSinglePicture.image = image
            scrollView.contentSize = screenSize
            bigSinglePicture.contentMode = .scaleAspectFill
            bigSinglePicture.frame = scrollView.bounds
        }
    
    @IBAction private func didTabBackButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}

extension SingleImageViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        bigSinglePicture
    }
}
