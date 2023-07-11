//
//  ProfileViewControllerProtocol.swift
//  ImageFeed
//
//  Created by Александр Поляков on 11.07.2023.
//

import Foundation
public protocol ProfileViewControllerProtocol: AnyObject {
    var presenter: ProfileViewPresenterProtocol? { get set }
}
