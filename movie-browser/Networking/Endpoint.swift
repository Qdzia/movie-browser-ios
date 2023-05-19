//
//  Endpoint.swift
//  movie-browser
//
//  Created by Łukasz Kudzia on 19/05/2023.
//

import Foundation

struct Endpoint {
    let path: String
    let queryItems: [URLQueryItem]
    let httpMethod: HttpMethod
    let headers: [String: String]
    
    init(path: String, queryItems: [URLQueryItem] = [], httpMethod: HttpMethod, headers: [String : String] = [:]) {
        self.path = path
        self.queryItems = queryItems
        self.httpMethod = httpMethod
        self.headers = headers
    }
}

enum HttpMethod: String {
    case get = "GET"
    case post = "POST"
}
