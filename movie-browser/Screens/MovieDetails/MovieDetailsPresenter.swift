//
//  MovieDetailsPresenter.swift
//  movie-browser
//
//  Created by Łukasz Kudzia on 22/05/2023.
//

import Foundation

protocol MovieDetailsPresentable {
    func toogleFavoriteMovie(_ movieId: Int)
    func fetchPosterImage(path: String)
    func isMovieInFavorites(_ movieId: Int) -> Bool
}

class MovieDetailsPresenter {
    weak var viewController: MovieDetailsViewController?
    var imageNetworkService: ImageNetworkService!
    var repository: FavoriteMoviesRepository!
    
    private func handleImageResult(_ result: Result<Data, NetworkError>) {
        switch result {
        case .success(let data):
            guard let image = imageNetworkService.createImage(from: data) else {
                Log.error("Couldn't create image")
                return
            }
            DispatchQueue.main.async { [weak self] in
                self?.viewController?.loadPoster(image)
            }

        case .failure(let error):
            Log.error("Couldn't load image due to: \(error.localizedDescription)")
        }
    }
}

extension MovieDetailsPresenter: MovieDetailsPresentable {
    func isMovieInFavorites(_ movieId: Int) -> Bool {
        repository.contains(movieId)
    }
    
    func toogleFavoriteMovie(_ movieId: Int) {
        repository.addOrRemove(movieId)
    }
    
    func fetchPosterImage(path: String) {
        guard let request = imageNetworkService.poster(path: path, size: .w342) else { return }
        imageNetworkService.sendRequest(request) { [weak self] result in
            self?.handleImageResult(result)
        }
    }
}
