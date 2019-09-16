//
//  APIService.swift
//  LoblawSolution
//
//  Created by Chris Ta on 2019-09-12.
//  Copyright © 2019 Loblaw. All rights reserved.
//

import Foundation

class NewsService {
    
    static let sharedInstance = NewsService()
    
    private let urlSession = URLSession.shared
    private let baseUrl = "https://www.reddit.com/r/swift/.json"
    private let jsonDecoder = JSONDecoder()
    
    func fetchNews(completion: @escaping(Result<[Article], APIServiceError>) -> Void) {
        
        guard let finalUrl = URL(string: baseUrl) else {
            return
        }
        
        urlSession.dataTask(with: finalUrl) { (result) in
            switch result {
            case .success(let (response, data)):
                guard let statusCode = (response as? HTTPURLResponse)?.statusCode, 200..<299 ~= statusCode else {
                    completion(.failure(.invalidResponse))
                    return
                }
                do {
                    let listingValue = try self.jsonDecoder.decode(ListingWrapper.self, from: data)
                    let articleArr = listingValue.data.children.map({ (articleWrapper) -> Article in
                        return articleWrapper.data
                    })
                    completion(.success(articleArr))
                } catch {
                    completion(.failure(.decodeError))
                }
            case .failure(let _):
                completion(.failure(.apiError))
            }
        }.resume()
    }
    
}

extension URLSession {
    func dataTask(with url: URL, result: @escaping (Result<(URLResponse, Data), Error>) -> Void) -> URLSessionDataTask {
        return dataTask(with: url) { (data, response, error) in
            if let error = error {
                result(.failure(error))
                return
            }
            guard let response = response, let data = data else {
                let error = NSError(domain: "error", code: 0, userInfo: nil)
                result(.failure(error))
                return
            }
            result(.success((response, data)))
        }
    }
}

public enum APIServiceError: Error {
    case apiError
    case invalidEndpoint
    case invalidResponse
    case noData
    case decodeError
}
