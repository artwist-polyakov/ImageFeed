//
//  ProfileViewController.swift
//  ImageFeed
//
//  Created by Александр Поляков on 11.05.2023.
//


import UIKit
class ProfileViewController: UIViewController {
    
    @IBOutlet var ProfileUserNameLabel: UILabel!
    @IBOutlet var logOutButton: UIButton!
    @IBOutlet var ProfileNickNameLabel: UILabel!
    @IBOutlet var ProfileStatusLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    @IBAction func logOutButtonTap(_ sender: Any) {
    }
}
