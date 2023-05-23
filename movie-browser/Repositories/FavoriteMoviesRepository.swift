//
//  FavoriteMoviesRepository.swift
//  movie-browser
//
//  Created by Łukasz Kudzia on 19/05/2023.
//

import Foundation

protocol FavoriteMoviesRepository {
    func add(_ movieId: Int)
    func remove(_ movieId: Int)
    func contains(_ movieId: Int) -> Bool
    func addOrRemove(_ movieId: Int)
}

class DefaultsFavoriteMoviesRepository {
    private let defaults = UserDefaults.standard
    private lazy var favoritesMoviesIds: Set<Int> = []
    
    func loadFavorites() {
        guard let list = defaults.load(forKey: .favoritesMovies) as? String else {
            return
        }
        let idsArray = list.components(separatedBy: ";").compactMap(Int.init)
        favoritesMoviesIds = Set(idsArray)
    }
    
    func saveFavorites() {
        let list = favoritesMoviesIds.map(String.init).joined(separator: ";")
        defaults.save(list, forKey: .favoritesMovies)
    }
    
    init() {
        loadFavorites()
    }
}

extension DefaultsFavoriteMoviesRepository: FavoriteMoviesRepository {
    func addOrRemove(_ movieId: Int) {
        if contains(movieId) {
            remove(movieId)
        } else {
            add(movieId)
        }
    }
    
    func add(_ movieId: Int) {
        favoritesMoviesIds.insert(movieId)
        saveFavorites()
    }
    
    func remove(_ movieId: Int) {
        favoritesMoviesIds.remove(movieId)
        saveFavorites()
    }
    
    func contains(_ movieId: Int) -> Bool {
        favoritesMoviesIds.contains(movieId)
    }
}
