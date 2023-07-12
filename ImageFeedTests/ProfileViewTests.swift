//
//  File.swift
//  ImageFeedTests
//
//  Created by Александр Поляков on 12.07.2023.
//

@testable import ImageFeed
import XCTest

final class ProfileViewTests: XCTestCase {
    func testProfileViewControllerCallsViewDidLoad() {
        // given
        let viewController = ProfileViewController()
        let presenter = ProfileViewPresenterSpy()
        viewController.presenter = presenter
        presenter.view = viewController
        
        // when
        _ = viewController.view
        
        // then
        XCTAssertTrue(presenter.viewDidLoadCalled)
    }
}
