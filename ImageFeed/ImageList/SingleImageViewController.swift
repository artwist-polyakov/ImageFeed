//
//  SingleImageViewController.swift
//  ImageFeed
//
//  Created by Александр Поляков on 12.05.2023.
//



import UIKit
final class SingleImageViewController: UIViewController {
    let feedbackGenerator = UIImpactFeedbackGenerator(style: .heavy)
    var image: UIImage! {
        didSet {
            guard isViewLoaded else { return }
            bigSinglePicture.image = image
            rescaleAndCenterImageInScrollView(image: image)
        }
    }
    
    @IBOutlet private weak var bigSinglePicture: UIImageView!
    @IBOutlet private weak var scrollView: UIScrollView!
    let screenSize = UIScreen.main.bounds.size
    @IBAction func didTapBackButton() {
        dismiss(animated: true, completion: nil)
    }
    @IBAction func didTapShareButton() {
        guard let sharingImage = bigSinglePicture
        else {
            feedbackGenerator.impactOccurred()
            return
        }
        let activityViewController = UIActivityViewController(activityItems: [sharingImage], applicationActivities: nil)
        present(activityViewController, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        feedbackGenerator.prepare()
        scrollView.minimumZoomScale = 0.1
        scrollView.maximumZoomScale = 20
        bigSinglePicture.image = image
        rescaleAndCenterImageInScrollView(image: image)
    }
    
    private func rescaleAndCenterImageInScrollView(image: UIImage) {
        let visibleRectSize = scrollView.bounds.size
        let imageSize = image.size
        let hScale = visibleRectSize.width / imageSize.width
        let vScale = visibleRectSize.height / imageSize.height
        let scale = min(scrollView.maximumZoomScale, max(scrollView.minimumZoomScale, min(hScale, vScale)))
        let targetWidth = imageSize.width * scale
        let targetHeight = imageSize.height * scale
        bigSinglePicture.frame = CGRect(x: 0, y: 0, width: targetWidth, height: targetHeight)
        scrollView.contentSize = bigSinglePicture.frame.size
        view.layoutIfNeeded()
        scrollView.layoutIfNeeded()
        scrollView.zoomScale = scale
        let verticalPadding =  max(0, (scrollView.contentSize.height - scrollView.bounds.height) / 2)
        
        let horizontalPadding =  max(0, (scrollView.contentSize.width - scrollView.bounds.width) / 2)
        scrollView.contentOffset = CGPoint(x: horizontalPadding, y: verticalPadding)
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        let imageViewSize = bigSinglePicture.frame.size
        let scrollViewSize = scrollView.bounds.size
        
        let verticalPadding = imageViewSize.height < scrollViewSize.height ? (scrollViewSize.height - imageViewSize.height) / 2 : 0
        let horizontalPadding = imageViewSize.width < scrollViewSize.width ? (scrollViewSize.width - imageViewSize.width) / 2 : 0
        
        scrollView.contentInset = UIEdgeInsets(top: verticalPadding, left: horizontalPadding, bottom: verticalPadding, right: horizontalPadding)
    }
}

extension SingleImageViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        bigSinglePicture
        
    }
}
