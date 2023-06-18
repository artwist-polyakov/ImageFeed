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
        
        // инициируем изображения для иконок внизу таб бара
        let imagesTabBarItem = UITabBarItem(title: "Images", image: UIImage(named: "tab_editorial_active"), selectedImage: UIImage(named: "tab_editorial_active"))
        let profileTabBarItem = UITabBarItem(title: "Profile", image: UIImage(named: "tab_profile_active"), selectedImage: UIImage(named: "tab_profile_active"))
        
        // находим наши вьюконтроллеры по идентификатору
        let storyboard = UIStoryboard(name: "Main", bundle: .main)
        let imagesListViewController = storyboard.instantiateViewController(
            withIdentifier: "ImagesListViewController"
        )
        let profileViewController = storyboard.instantiateViewController(
            withIdentifier: "ProfileViewController"
        )
        
        // присваиваем вью контроллерам иконки для таб бара
        imagesListViewController.tabBarItem = imagesTabBarItem
        profileViewController.tabBarItem = profileTabBarItem
        
        // указываем с какими вью контроллерами связан таб бар
        self.viewControllers = [imagesListViewController, profileViewController]
    }
}
