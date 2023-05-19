//
//  MovieNetworkService.swift
//  movie-browser
//
//  Created by Łukasz Kudzia on 19/05/2023.
//

import Foundation


class MovieNetworkService: NetworkService {
    func nowPlayingMovies(page: Int) -> URLRequest? {
        let queryItems = [
            URLQueryItem(name: "page", value: String(page))
        ]
                
        let endpoint = Endpoint(path: "/3/movie/now_playing", queryItems: queryItems, httpMethod: .get)
        return createRequest(endpoint: endpoint)
    }
    
    func searchMovies(query: String, page: Int) -> URLRequest? {
        let queryItems = [
            URLQueryItem(name: "query", value: query),
            URLQueryItem(name: "page", value: String(page))
        ]
        
        let endpoint = Endpoint(path: "/3/search/movie", queryItems: queryItems, httpMethod: .get)
        return createRequest(endpoint: endpoint)
    }
    
    init() {
        super.init(host: "api.themoviedb.org", scheme: "https", timeoutInterval: 10.0)
    }
}
