//
//  NetworkService.swift
//  ImageFeed
//
//  Created by Александр Поляков on 16.06.2023.
//

import Foundation
protocol NetworkService {
    func object<T: Decodable>(
        for request: URLRequest,
        completion: @escaping (Result<T, Error>) -> Void
    ) -> URLSessionTask
}

extension NetworkService {
    func object<T: Decodable>(
        for request: URLRequest,
        completion: @escaping (Result<T, Error>) -> Void
    ) -> URLSessionTask {
        let decoder = JSONDecoder()
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                let error = NetworkError.urlSessionError
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
                let result = try decoder.decode(T.self, from: data)
                completion(.success(result))
            } catch {
                completion(.failure(error))
            }
        }
        
        return task
    }
}
