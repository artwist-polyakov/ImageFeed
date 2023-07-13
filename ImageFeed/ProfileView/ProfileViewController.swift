//
//  ProfileViewController.swift
//  ImageFeed
//
//  Created by Александр Поляков on 11.05.2023.
//
import UIKit

class ProfileViewController: UIViewController & ProfileViewControllerProtocol {
    
    // MARK: -  VARIABLES
    var presenter: ProfileViewPresenterProtocol = ProfileViewPresenter()
    var userDescription: UILabel!
    var userNickName: UILabel!
    var userName: UILabel!
    
    private let alertPresenter = AlertPresenter()
    static let LogoutNotification = Notification.Name(rawValue: "Logoutcompleted")
    
    // MARK: -  INTERFACE INIT METHODS
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
    
    // MARK: -  VIEW DID LOAD
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initProfileImage (view: view)
        self.initLogoutButton(view: view)
        self.initLabels(view: view)
        presenter.viewDidLoad()                                  // 7
        
    }
    
    // MARK: -  LOGOUT BUTON
    @objc
    private func didTapLogoutButton() {
        let primaryButtonCompletion = {
            NotificationCenter.default.post(
                name: ProfileViewController.LogoutNotification,
                object: self,
                userInfo: nil)
            self.presenter.clearSecretsAndData()
            for view in self.view.subviews {
                if view is UILabel {
                    view.removeFromSuperview()
                } else {
                    if let imageView = view as? UIImageView {
                        imageView.image = UIImage(named: "ProfilePhotoPlaceholder")
                        imageView.tintColor = UIColor(named: "YP Gray")
                    }
                }
            }
            self.present(SplashViewController(), animated: true, completion: nil)
        }
        
        let alert = AlertModel(title: "Пока, пока!", message: "Уверены, что хотите выйти?", primaryButtonText: "Да", primaryButtonCompletion: primaryButtonCompletion, secondaryButtonText: "Нет") {}
        
        alertPresenter.show(in: self, model:alert)
    }
    
    func configure(_ presenter: ProfileViewPresenterProtocol) {
        self.presenter = presenter
        self.presenter.view = self
    }
    
}



