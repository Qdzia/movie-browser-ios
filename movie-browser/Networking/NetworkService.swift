//
//  NetworkService.swift
//  movie-browser
//
//  Created by Łukasz Kudzia on 19/05/2023.
//

import Foundation
import UIKit

enum NetworkError: Error {
    case missingData
    case badStatusCode(Int)
    case missingResponse
    case other(Error)
}

class NetworkService {
    private let host: String
    private let scheme: String
    private let timeoutInterval: TimeInterval
    private let defaultSession = URLSession(configuration: .default)
    private var dataTask: URLSessionDataTask?
    
    private let defaultHeaders = {
        let apiKey = Bundle.main.infoDictionary?["MySecretApiKey"] as? String ?? ""
        
        if apiKey.isEmpty {
            Log.error("Missing ApiKey from infoDictionary")
        }
        
        return [
            "accept": "application/json",
            "Authorization": "Bearer \(apiKey)"
        ]
    }()
    
    func createRequest(endpoint: Endpoint) -> URLRequest? {
        var components = URLComponents()
        components.scheme = scheme
        components.host = host
        components.path = endpoint.path
        components.queryItems = endpoint.queryItems
        
        guard let url = components.url else {
            Log.error("Missing URL from URLComponents")
            return nil
        }
        
        let request = NSMutableURLRequest(
            url: url,
            cachePolicy: .useProtocolCachePolicy,
            timeoutInterval: timeoutInterval
        )
        
        request.httpMethod = endpoint.httpMethod.rawValue
        
        var headers = defaultHeaders
        endpoint.headers.forEach { (key, value) in headers[key] = value }
        request.allHTTPHeaderFields = headers
        
        return request as URLRequest
    }
    
    func sendRequest(_ request: URLRequest, completion: @escaping (Result<Data, NetworkError>) -> ()) {
        dataTask?.cancel()

        dataTask = defaultSession.dataTask(with: request, completionHandler: {  [weak self] data, response, error -> Void in
            defer {
                self?.dataTask = nil
            }
            
            if let error = error {
                completion(.failure(.other(error)))
                return
            }
            
            guard let data = data else {
                completion(.failure(.missingData))
                return
            }
            
            guard let response = response as? HTTPURLResponse else {
                completion(.failure(.missingResponse))
                return
            }
            
            guard (200...299).contains(response.statusCode) else {
                completion(.failure(.badStatusCode(response.statusCode)))
                return
            }

            completion(.success(data))
        })
        
        dataTask?.resume()
    }
    
    func parseJSON<T: Decodable>(data: Data) -> T? {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
    
        do {
            let model: T = try decoder.decode(T.self, from: data)
            return model
        } catch {
            Log.error("Unable to decode data")
            return nil
        }
    }
    
    func createImage(from data: Data) -> UIImage? {
        if let image = UIImage(data: data) {
            return image
        } else {
            Log.error("Unable to create image from data")
            return nil
        }
    }
    
    init(host: String, scheme: String, timeoutInterval: TimeInterval) {
        self.host = host
        self.scheme = scheme
        self.timeoutInterval = timeoutInterval
    }
}
