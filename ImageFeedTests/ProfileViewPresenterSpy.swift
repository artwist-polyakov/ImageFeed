//
//  ProfileViewPresenterSpy.swift
//  ImageFeedTests
//
//  Created by Александр Поляков on 12.07.2023.
//
import ImageFeed
import Foundation
final class ProfileViewPresenterSpy: ProfileViewPresenterProtocol {
    var view: ImageFeed.ProfileViewControllerProtocol?
    private let profileService = ProfileServiceStub.shared
    var viewDidLoadCalled: Bool = false
    var didUpdateProfileCalled: Bool = false
    
    func viewDidLoad() {
        viewDidLoadCalled = true
    }
    
    func updateProfileDetails() {
        guard let view = self.view else {return}
        view.userDescription.text = profileService.profile?.bio ?? ""
        view.userNickName.text = profileService.profile?.loginName
        view.userName.text = profileService.profile?.name ?? ""
        didUpdateProfileCalled = true
        
    }
    
    func updateAvatar(tag: Int) {
    }
    
    func clearSecretsAndData() {
    }
    
    
}
