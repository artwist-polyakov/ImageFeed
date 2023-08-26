//
//  SingleImageViewController.swift
//  ImageFeed
//
//  Created by Александр Поляков on 12.05.2023.
//



import UIKit
final class SingleImageViewController: UIViewController {
    let feedbackGenerator = UIImpactFeedbackGenerator(style: .heavy)
    private static var window: UIWindow? {
        return UIApplication.shared.windows.first
    }
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
    // MARK: viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        feedbackGenerator.prepare()
        scrollView.minimumZoomScale = 0.01
        scrollView.maximumZoomScale = 200
        let indicator = ProgressHUDIndicator()
        bigSinglePicture.kf.indicatorType = .custom(indicator: indicator)
        guard let url = URL(string: imageToLoad.largeImageURL ) else { return }
        loadImage(from: url)
    }
    
    // MARK: rescaleAndCenterImageInScrollView
    private func rescaleAndCenterImageInScrollView(image: UIImage) {
        let minZoomScale = scrollView.minimumZoomScale
        let maxZoomScale = scrollView.maximumZoomScale
        
        view.layoutIfNeeded()
        
        let visibleRectSize = scrollView.bounds.size
        
        let imageSize = image.size
        
        let hScale = visibleRectSize.width / imageSize.width
        let vScale = visibleRectSize.height / imageSize.height
        
        let scale = min(maxZoomScale, max(minZoomScale, min(hScale, vScale)))
        
        scrollView.setZoomScale (scale, animated: false)
        scrollView.layoutIfNeeded ()
        
        let newContentSize = scrollView.contentSize
        let x = (newContentSize.width - visibleRectSize.width) / 2
        let y = (newContentSize.height - visibleRectSize.height) / 2
        
        scrollView.setContentOffset(CGPoint(x: x, y: y), animated: false)
    }
    
    // MARK: scrollViewDidZoom
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        let imageViewSize = bigSinglePicture.frame.size
        let scrollViewSize = scrollView.bounds.size
        
        let verticalPadding = imageViewSize.height < scrollViewSize.height ? (scrollViewSize.height - imageViewSize.height) / 2 : 0
        let horizontalPadding = imageViewSize.width < scrollViewSize.width ? (scrollViewSize.width - imageViewSize.width) / 2 : 0
        
        scrollView.contentInset = UIEdgeInsets(top: verticalPadding, left: horizontalPadding, bottom: verticalPadding, right: horizontalPadding)
    }
    
    // MARK: loadImage
    func loadImage(from url:URL) {
        SingleImageViewController.window?.isUserInteractionEnabled = false
        bigSinglePicture.kf.setImage(with: url) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let value):
                self.bigSinglePicture.image = value.image
                self.rescaleAndCenterImageInScrollView(image: value.image)
                SingleImageViewController.window?.isUserInteractionEnabled = true
            case .failure:
                let alertPresenter = AlertPresenter()
                let alert = AlertModel(title: "УПС!", message: "Что-то пошло не так", primaryButtonText: "Не надо", primaryButtonCompletion: {
                }, secondaryButtonText: "Повторить") {
                    self.loadImage(from: url)
                }
                SingleImageViewController.window?.isUserInteractionEnabled = true
                alertPresenter.show(in: self, model:alert)
            }
        }
    }
}

extension SingleImageViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        bigSinglePicture
        
    }
}
