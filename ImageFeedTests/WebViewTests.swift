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
    
    func testPresenterCallsLoadRequest() {
        // given
        let viewController = WebViewViewControllerSpy()
        let authHelper = AuthHelper()
        let presenter = WebViewPresenter(authHelper: authHelper)
        viewController.presenter = presenter
        presenter.view = viewController
        
        // when
        presenter.viewDidLoad()
        
        // then
        XCTAssertTrue(viewController.didRequestLoaded)
    }
    
    func testProgressHiddenWhenOne() {
        // given
        let authHelper = AuthHelper()
        let presenter = WebViewPresenter(authHelper: authHelper)
        let progress: Float = 1.0
        
        //when
        let shouldHideProgress = presenter.shouldHideProgress(for: progress)
        
        //then
        XCTAssertTrue(shouldHideProgress)
    }
    
    func testProgressVisibleWhenLessThenOne() {
        // given
        let authHelper = AuthHelper() // Dummy
        let presenter = WebViewPresenter(authHelper: authHelper)
        let progress: Float = 0.6
        
        // when
        let shouldHideProgress = presenter.shouldHideProgress(for: progress)
        
        // then
        XCTAssertFalse(shouldHideProgress)
    }
    
    func testAuthHelperAuthURL() {
        // given
        let configuration = AuthConfiguration.standard
        let authHelper = AuthHelper(configuration: configuration)
        
        // when
        let url = authHelper.authURL()
        let urlString = url.absoluteString
        
        // then
        XCTAssertTrue(urlString.contains(configuration.authURLString))
        XCTAssertTrue(urlString.contains(configuration.accessKey))
        XCTAssertTrue(urlString.contains(configuration.redirectURI))
        XCTAssertTrue(urlString.contains("code"))
        XCTAssertTrue(urlString.contains(configuration.accessScope))
    }
    
    func testCodeFromURL() {
        // given
        let authHelper = AuthHelper()
        guard let url = URL(string: "https://unsplash.com/oauth/authorize/native"),
              var components = URLComponents(url: url, resolvingAgainstBaseURL: true)
        else {return}
        components.queryItems = [
            URLQueryItem(name: "code", value: "test code")]
        guard let testUrl = components.url else {return}
        
        // when
        let code = authHelper.code(from: testUrl)
        
        // then
        XCTAssertEqual(code, "test code")
        
    }
    
    
    
}

