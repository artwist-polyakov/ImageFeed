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
            rescaleAndCenterImageInScrollView(image: image)
        }
    }
    @IBOutlet var bigSinglePicture: UIImageView!
    
    @IBOutlet var scrollView: UIScrollView!
    let screenSize = UIScreen.main.bounds.size
    
    @IBAction func didTapBackButton() {
        dismiss(animated: true, completion: nil)
    }
    
    
    
    override func viewDidLoad() {
        
            super.viewDidLoad()
            scrollView.minimumZoomScale = 1
            scrollView.maximumZoomScale = 3
            bigSinglePicture.image = image
        rescaleAndCenterImageInScrollView(image: image)
        }
    
    private func rescaleAndCenterImageInScrollView(image: UIImage) {
        let minZoomScale = scrollView.minimumZoomScale
        let maxZoomScale = scrollView.maximumZoomScale
        print("minZoomScale = \(minZoomScale)")
        print("maxZoomScale = \(maxZoomScale)")
        view.layoutIfNeeded()
        let visibleRectSize = scrollView.bounds.size
        print("visibleRectSize = \(visibleRectSize): \(visibleRectSize.width), \(visibleRectSize.height)")
        let imageSize = image.size
        print("Размер картинки \(imageSize): \(imageSize.width), \(imageSize.height)")
        let hScale = visibleRectSize.width / imageSize.width
        let vScale = visibleRectSize.height / imageSize.height
        let scale = min(maxZoomScale, max(minZoomScale, max(hScale, vScale)))
        scrollView.setZoomScale(scale, animated: false)
        scrollView.layoutIfNeeded()
        let newContentSize = scrollView.contentSize
        let x = (newContentSize.width - visibleRectSize.width) / 2
        let y = (newContentSize.height - visibleRectSize.height) / 2
        scrollView.setContentOffset(CGPoint(x: x, y: y), animated: false)
    }

    
}

extension SingleImageViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        bigSinglePicture
    }
    
    func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {
        bigSinglePicture.image = image
        rescaleAndCenterImageInScrollView(image: image)
        
    }
}
