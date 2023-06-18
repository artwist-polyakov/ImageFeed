//
//  ProfileViewController.swift
//  ImageFeed
//
//  Created by Александр Поляков on 11.05.2023.
//
import UIKit
import Kingfisher

class ProfileViewController: UIViewController {
    private var userDescription: UILabel!
    private var userNickName: UILabel!
    private var userName: UILabel!
    private let profileService = ProfileService.shared
    private var profileImageServiceObserver: NSObjectProtocol?
    
    
    private func initProfileImage (view: UIView) {
        view.backgroundColor = UIColor(named: "YP Black")
        let profileImage = UIImage(named: "ProfilePhotoPlaceholder") ?? UIImage(named: "ProfilePhotoPlaceholder")
        let profilePhotoView = UIImageView(image: profileImage)
        profilePhotoView.layer.cornerRadius = profilePhotoView.frame.width / 2
        profilePhotoView.clipsToBounds = true
        if profileImage ==  UIImage(named: "ProfilePhotoPlaceholder") {
            profilePhotoView.tintColor = UIColor(named: "YP Gray")
        }
        profilePhotoView.tag = 1
        view.addSubview(profilePhotoView)
        
        profilePhotoView.translatesAutoresizingMaskIntoConstraints = false
        profilePhotoView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16).isActive = true
        profilePhotoView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40).isActive = true
        profilePhotoView.heightAnchor.constraint(equalToConstant: 70).isActive = true
        profilePhotoView.widthAnchor.constraint(equalToConstant: 70).isActive = true
        
    }
    
    private func initLogoutButton(view: UIView) {
        let logOutButton = UIButton.systemButton(
            with: UIImage(systemName: "ipad.and.arrow.forward")!,
            target: self,
            action: #selector(Self.didTapLogoutButton)
        )
        
        logOutButton.tintColor = UIColor(named: "YP Red")
        view.addSubview(logOutButton)
        logOutButton.translatesAutoresizingMaskIntoConstraints = false
        logOutButton.centerYAnchor.constraint(equalTo: view.viewWithTag(1)!
            .centerYAnchor).isActive = true
        logOutButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -24).isActive = true
    }
    
    private func initLabels(view: UIView) {
        userName = UILabel()
        userName.text = "Екатерина Новикова"
        userName.textColor = UIColor(named: "YP White")
        let boldFontSize: CGFloat = 23
        let boldFont = UIFont.systemFont(ofSize: boldFontSize, weight: .bold)
        userName.font = boldFont
        view.addSubview(userName)
        userName.translatesAutoresizingMaskIntoConstraints = false
        userName.topAnchor.constraint(equalTo: view.viewWithTag(1)!.bottomAnchor, constant: 8).isActive = true
        userName.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16).isActive = true
        
        userNickName = UILabel()
        userNickName.text = "@ekaterina_nov"
        userNickName.textColor = UIColor(named: "YP Gray")
        let regularFontSize: CGFloat = 13
        let regularFont = UIFont.systemFont(ofSize: regularFontSize, weight: .regular)
        userNickName.font = regularFont
        view.addSubview(userNickName)
        userNickName.translatesAutoresizingMaskIntoConstraints = false
        userNickName.topAnchor.constraint(equalTo: userName.bottomAnchor, constant: 8).isActive = true
        userNickName.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16).isActive = true
        
        userDescription = UILabel()
        userDescription.text = "Hello, world!"
        userDescription.textColor = UIColor(named: "YP White")
        userDescription.font = regularFont
        view.addSubview(userDescription)
        view.addSubview(userDescription)
        userDescription.translatesAutoresizingMaskIntoConstraints = false
        userDescription.topAnchor.constraint(equalTo: userNickName.bottomAnchor, constant: 8).isActive = true
        userDescription.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16).isActive = true
    }
    
    private func updateProfileDetails (profile: Profile) {
        userDescription.text = profile.bio ?? ""
        userNickName.text = profile.loginName
        userName.text = profile.name ?? ""
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initProfileImage (view: view)
        initLogoutButton(view: view)
        initLabels(view: view)
        updateProfileDetails(profile: profileService.profile!)
        profileImageServiceObserver = NotificationCenter.default.addObserver(
                        forName: ProfileImageService.DidChangeNotification, // 3
                        object: nil,                                        // 4
                        queue: .main                                        // 5
                    ) { [weak self] _ in
                        guard let self = self else { return }
                        self.updateAvatar()                                 // 6
                    }
        updateAvatar()                                              // 7

    }
    
    private func updateAvatar() {                                   // 8
        guard
                let profileImageURL = ProfileImageService.shared.avatarURL,
                let url = URL(string: profileImageURL),
                let imageView = view.viewWithTag(1) as? UIImageView
            else { return }
            let processor = RoundCornerImageProcessor(cornerRadius: imageView.frame.width / 2)
            let placeholderImage = UIImage(named: "ProfilePhotoPlaceholder")
            imageView.kf.setImage(with: url,
                                  placeholder: placeholderImage,
                                  options: nil,
                                  completionHandler: { [weak self] result in
                                        guard self != nil else { return }
                                      
                                      switch result {
                                      case .success(let value):
                                          // Загрузка изображения прошла успешно
                                          print("Фотокарточка загружена: \(value.source.url?.absoluteString ?? "")")
                                      case .failure(let error):
                                          // Возникла ошибка при загрузке изображения
                                          print("Фотокарточка не загружена: \(error)")
                                      }
                                  })

        }
    
    @objc
    private func didTapLogoutButton() {
        let tokenStorage = OAuth2TokenStorage.shared
        tokenStorage.removeToken()
        for view in view.subviews {
            if view is UILabel {
                view.removeFromSuperview()
            } else {
                if let imageView = view as? UIImageView {
                    imageView.image = UIImage(named: "ProfilePhotoPlaceholder")
                    imageView.tintColor = UIColor(named: "YP Gray")
                }
            }
        }
        // После логаута мы должны снова запустить наш Сплешскрин — instantiateInitialViewController()
        UIApplication.shared.windows.first?.rootViewController = UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController()
        
    }
}



