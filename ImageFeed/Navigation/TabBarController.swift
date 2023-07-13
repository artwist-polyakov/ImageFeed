//
//  TabBarController.swift
//  ImageFeed
//
//  Created by Александр Поляков on 18.06.2023.
//

import UIKit

final class TabBarController: UITabBarController {
    override func awakeFromNib() {
        super.awakeFromNib()
        
        //        UIBlockingProgressHUD.dismiss()
        // находим наши вьюконтроллеры по идентификатору
        let storyboard = UIStoryboard(name: "Main", bundle: .main)
        let imagesListViewController = storyboard.instantiateViewController(
            withIdentifier: "ImagesListViewController"
        )
        
        let profileViewController = ProfileViewController()
        profileViewController.configure(ProfileViewPresenter())
        
        // присваиваем вью контроллерам иконки для таб бара
        imagesListViewController.tabBarItem = UITabBarItem(
            title: "Images Feed",
            image: UIImage(named: "tab_editorial_active"),
            selectedImage: nil
        )
        
        profileViewController.tabBarItem = UITabBarItem(
            title: "Profile",
            image: UIImage(named: "tab_profile_active"),
            selectedImage: nil
        )
        
        // указываем с какими вью контроллерами связан таб бар
        self.viewControllers = [imagesListViewController, profileViewController]
    }
}
