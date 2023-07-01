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
    var imageToLoad: Photo!
    
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
        scrollView.minimumZoomScale = 0.01
        scrollView.maximumZoomScale = 200
        let indicator = ProgressHUDIndicator()
        bigSinglePicture.kf.indicatorType = .custom(indicator: indicator)
        let url = URL(string: imageToLoad.largeImageURL)
        bigSinglePicture.kf.setImage(with: url) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let value):
                self.bigSinglePicture.image = value.image
                self.rescaleAndCenterImageInScrollView(image: value.image)
            case .failure(let error):
                print("Failed to load image: \(error)")
            }
        }
    }
    
    private func rescaleAndCenterImageInScrollView(image: UIImage) {
        let visibleRectSize = scrollView.bounds.size
        let imageSize = image.size
        let hScale = visibleRectSize.width / imageSize.width
        let vScale = visibleRectSize.height / imageSize.height
        let scale = min(scrollView.maximumZoomScale, max(scrollView.minimumZoomScale, min(hScale, vScale)))
        let targetWidth = imageSize.width * scale
        let targetHeight = imageSize.height * scale
        print("verticalPadding scale = \(scale), visibleRectSize = \(visibleRectSize), imageSize= \(imageSize) ")
        print("verticalPadding targetWidth = \(targetWidth), targetHeight = \(targetHeight) ")

        bigSinglePicture.frame = CGRect(x: 0, y: 0, width: targetWidth, height: targetHeight)
        scrollView.contentSize = bigSinglePicture.frame.size
        print("verticalPadding scrollView.contentSize = \( scrollView.contentSize)")
        print("verticalPadding scrollView.bounds.height = \( scrollView.contentSize)")

        view.layoutIfNeeded()
        scrollView.layoutIfNeeded()
        scrollView.zoomScale = scale
        let verticalPadding =  max(0, (scrollView.bounds.height - scrollView.contentSize.height) / 2)
        print("verticalPadding = \(verticalPadding)")
        let horizontalPadding =  max(0, (scrollView.bounds.width - scrollView.contentSize.width) / 2)
        print("verticalPadding horizontalPadding= \(horizontalPadding)")

//        scrollView.contentOffset = CGPoint(x: horizontalPadding, y: verticalPadding)
        scrollView.contentInset = UIEdgeInsets(top: verticalPadding, left: horizontalPadding, bottom: verticalPadding, right: horizontalPadding)
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
