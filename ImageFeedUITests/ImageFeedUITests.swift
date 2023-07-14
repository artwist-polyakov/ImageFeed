//
//  ImageFeedUITests.swift
//  ImageFeedUITests
//
//  Created by Александр Поляков on 14.07.2023.
//

import XCTest

final class ImageFeedUITests: XCTestCase {
    
    private let app = XCUIApplication() // переменная приложения
    

    override func setUpWithError() throws {
        continueAfterFailure = false // настройка выполнения тестов, которая прекратит выполнения тестов, если в тесте что-то пошло не так
        app.launch() // запускаем приложение перед каждым тестом
    }
    
    func testAuth() throws {
        // тестируем сценарий авторизации
        /*
          У приложения мы получаем список кнопок на экране и получаем нужную кнопку по тексту на ней
          Далее вызываем функцию tap() для нажатия на этот элемент
        */
        app.buttons["Authenticate"].tap()
        // Подождать, пока экран авторизации открывается и загружается
        let webView = app.webViews["UnsplashWebView"]
        webView.waitForExistence(timeout: 5)
        let loginTextField = webView.descendants(matching: .textField).element
        let passwordTextField = webView.descendants(matching: .secureTextField).element
        loginTextField.typeText("master@artwist.ru")
        // Ввести данные в форму
        webView.swipeUp()
        // Нажать кнопку логина
        print(app.debugDescription)
        // Подождать, пока открывается экран ленты
        }
        
    func testFeed() throws {
        // тестируем сценарий ленты
    }
    
    func testProfile() throws {
        // тестируем сценарий профиля
    }

}
