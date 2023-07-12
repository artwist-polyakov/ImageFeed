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
    var viewDidLoadCalled: Bool = false
    
    func viewDidLoad() {
        viewDidLoadCalled = true
    }
    
    func updateProfileDetails() {
        
    }
    
    func updateAvatar(tag: Int) {
        
    }
    
    func clearSecretsAndData() {
        
    }
    
    
}
