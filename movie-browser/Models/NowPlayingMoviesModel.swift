//
//  NowPlayingMoviesModel.swift
//  movie-browser
//
//  Created by Łukasz Kudzia on 19/05/2023.
//

import Foundation

struct NowPlayingMoviesModel: Decodable {
    let results: [MovieModel]
    let totalPages: Int
    let totalResults: Int
}
