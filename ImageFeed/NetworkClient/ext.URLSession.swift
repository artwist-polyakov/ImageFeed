//
//  ext.URLSession.swift
//  ImageFeed
//
//  Created by Александр Поляков on 16.06.2023.
//

import Foundation
extension URLSession {
    func objectTask<T: Decodable>(
        for request: URLRequest,
        completion: @escaping (Result<T, Error>) -> Void
    ) -> URLSessionTask {
        let task = dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    completion(.failure(error))
                    return
                }
                
                guard let httpResponse = response as? HTTPURLResponse else {
                    let error = NetworkError.urlSessionError
                    completion(.failure(error))
                    return
                }
                
                let statusCode = httpResponse.statusCode
                guard 200..<300 ~= statusCode else {
                    let error = NetworkError.httpStatusCode(statusCode)
                    completion(.failure(error))
                    return
                }
                
                do {
                    let decoder = JSONDecoder()
                    let result = try decoder.decode(T.self, from: data!)
                    completion(.success(result))
                } catch {
                    completion(.failure(error))
                }
            }
        }
        return task
    }
}

extension URLRequest {
    static func makeHTTPRequest(
        path: String,
        httpMethod: String,
        baseURL: URL = DefaultBaseURL,
        needToken: Bool = false
    ) -> URLRequest {
        var request = URLRequest(url: URL(string: path, relativeTo: baseURL)!)
        request.httpMethod = httpMethod
        if (needToken) {
            guard let authToken = OAuth2TokenStorage().token else {
                return request
            }
            request.setValue("Bearer \(authToken)", forHTTPHeaderField: "Authorization")
        }
        return request
    }
}

