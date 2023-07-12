//
//  ProfileViewPresenter.swift
//  ImageFeed
//
//  Created by Александр Поляков on 12.07.2023.
//

import Foundation
import UIKit
import Kingfisher
import WebKit
final class ProfileViewPresenter: ProfileViewPresenterProtocol {
    
    var view: ProfileViewControllerProtocol?
    private let profileService = ProfileService.shared
    private var profileImageServiceObserver: NSObjectProtocol?
    
    init(view:ProfileViewControllerProtocol?){
        guard let view = view else {return}
        self.view = view
    }
    
    func viewDidLoad() {
        self.updateProfileDetails()
        profileImageServiceObserver = NotificationCenter.default.addObserver(
            forName: ProfileImageService.DidChangeNotification,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            guard let self = self
            else { return }
            self.updateAvatar(tag: 1)
        }
        self.updateAvatar(tag: 1)
    }
    
    
    func updateProfileDetails() {
        guard let view = self.view else {return}
        view.userDescription.text = profileService.profile?.bio ?? ""
        view.userNickName.text = profileService.profile?.loginName
        view.userName.text = profileService.profile?.name ?? ""
    }
    
    func updateAvatar(tag: Int) {
        guard
            let profileImageURL = ProfileImageService.shared.avatarURL,
            let url = URL(string: profileImageURL),
            let targetView = self.view?.view.viewWithTag(tag),
                let imageView = targetView as? UIImageView
        else { return }
        let processor = RoundCornerImageProcessor(cornerRadius: imageView.frame.width / 2)
        let placeholderImage = UIImage(named: "ProfilePhotoPlaceholder")
        imageView.kf.setImage(with: url,
                              placeholder: placeholderImage,
                              options: [.processor(processor)],
                              completionHandler: { [weak self] result in
            guard self != nil else { return }
            switch result {
            case .success(let value):
                // Загрузка изображения прошла успешно
                print("Фотография загружена: \(value.source.url?.absoluteString ?? "")")
            case .failure(let error):
                // Возникла ошибка при загрузке изображения
                print("Фотография не загружена: \(error)")
            }
        })
    }
    
    func clearSecretsAndData() {
        let tokenStorage = OAuth2TokenStorage.shared
        tokenStorage.removeToken()
        HTTPCookieStorage.shared.removeCookies(since: Date.distantPast)
        // Запрашиваем все данные из локального хранилища.
        WKWebsiteDataStore.default().fetchDataRecords(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes()) { records in
            // Массив полученных записей удаляем из хранилища.
            records.forEach { record in
                WKWebsiteDataStore.default().removeData(ofTypes: record.dataTypes, for: [record], completionHandler: {})
            }
        }
    }
    
    
}
