//
//  ProfileViewPresenterProtocol.swift
//  ImageFeed
//
//  Created by Александр Поляков on 11.07.2023.
//

import Foundation
public protocol ProfileViewPresenterProtocol {
    var view: ProfileViewControllerProtocol? { get set }
    func viewDidLoad()
    func didTapLogoutButton()
    func updateProfileDetails(profile: Profile)
    func updateAvatar()
    func clearSecretsAndData()
}
