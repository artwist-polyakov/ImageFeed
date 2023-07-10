//
//  AuthHelperProtocol.swift
//  ImageFeed
//
//  Created by Александр Поляков on 10.07.2023.
//

import Foundation
protocol AuthHelperProtocol {
    func authRequest() -> URLRequest
    func code(from url: URL) -> String?
}
