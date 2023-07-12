//
//  ProfileViewControllerProtocol.swift
//  ImageFeed
//
//  Created by Александр Поляков on 11.07.2023.
//

import Foundation
import UIKit

public protocol ProfileViewControllerProtocol: UIViewController {
    var presenter: ProfileViewPresenterProtocol? { get set }
    var userDescription: UILabel! { get set }
    var userNickName: UILabel! { get set }
    var userName: UILabel! { get set }
}
