//
//  ImageNetworkService.swift
//  movie-browser
//
//  Created by Łukasz Kudzia on 19/05/2023.
//

import Foundation

enum PosterSize: String {
    case w92
    case w154
    case w185
    case w342
    case w500
    case w780
    case original
}

class ImageNetworkService: NetworkService {
    func poster(path: String, size: PosterSize) -> URLRequest? {
        let endpoint = Endpoint(path: "/t/p/\(size.rawValue)" + path, httpMethod: .get)
        return createRequest(endpoint: endpoint)
    }
    
    init() {
        super.init(host: "image.tmdb.org", scheme: "https", timeoutInterval: 10.0)
    }
}
