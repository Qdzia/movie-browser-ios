//
//  MovieListPresenter.swift
//  movie-browser
//
//  Created by Łukasz Kudzia on 22/05/2023.
//

import Foundation

protocol MovieListPresentable {
    func fetchMovieList()
    func toggleFavoriteFilter()
    func toogleFavoriteMovie(_ movieId: Int)
    func isMovieInFavorites(_ movieId: Int) -> Bool
}

class MovieListPresenter {
    private var movies: [MovieModel] = []
    private var isFavoriteFilterOn = false
    
    var movieNetworkService: MovieNetworkService!
    var repository: FavoriteMoviesRepository!
    weak var viewController: MovieListViewController?
    
    private func handleMovieResult(_ result: Result<Data, NetworkError>) {
        switch result {
        case .success(let data):
            guard let model: NowPlayingMoviesModel = movieNetworkService.parseJSON(data: data) else { return }
            movies = model.results
            DispatchQueue.main.async { [weak self] in
                self?.viewController?.loadMovies(model.results)
            }

        case .failure(let error):
            Log.error("Couldn't load list due to: \(error.localizedDescription)")
        }
    }
}

extension MovieListPresenter: MovieListPresentable {
    func fetchMovieList() {
        guard let request = movieNetworkService.nowPlayingMovies(page: 1) else { return }
        movieNetworkService.sendRequest(request) { [weak self] result in
            self?.handleMovieResult(result)
        }
    }
    
    func toggleFavoriteFilter() {
        isFavoriteFilterOn.toggle()
        let filteredMovies = isFavoriteFilterOn ? movies.filter { repository.contains($0.id) } : movies
        viewController?.loadMovies(filteredMovies)
    }
    
    func toogleFavoriteMovie(_ movieId: Int) {
        repository.addOrRemove(movieId)
    }
    
    func isMovieInFavorites(_ movieId: Int) -> Bool {
        repository.contains(movieId)
    }
}
