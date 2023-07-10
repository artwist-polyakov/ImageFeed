//
//  ImageFeedTests.swift
//  ImageFeedTests
//
//  Created by Александр Поляков on 10.07.2023.
//
@testable import ImageFeed
import XCTest

final class ImageFeedTests: XCTestCase {
    func testViewControllerCallsViewDidLoad() {
        
        // given
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "WebViewViewController") as! WebViewViewController
        let presenter = WebViewPresenterSpy()
        viewController.presenter = presenter
        presenter.view = viewController
        
        // when
        _ = viewController.view
        
        // then
        XCTAssertTrue(presenter.viewDidLoadCalled)
    }
    
}

