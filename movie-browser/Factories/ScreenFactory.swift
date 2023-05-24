//
//  ScreenFactory.swift
//  movie-browser
//
//  Created by Łukasz Kudzia on 24/05/2023.
//

import Swinject

class ScreenFactory {
    static func registerScreens(in container: Container) {
        container.register(MovieListViewController.self) { r in
            let vc = MovieListViewController()
            vc.presenter = MovieListPresenter()
            vc.presenter.movieNetworkService = r.resolve(MovieNetworkService.self)
            vc.presenter.repository = r.resolve(FavoriteMoviesRepository.self)
            vc.presenter.viewController = vc
            return vc
        }
        
        container.register(MovieDetailsViewController.self) { r, movie in
            let vc = MovieDetailsViewController()
            vc.movie = movie
            vc.presenter = MovieDetailsPresenter()
            vc.presenter.imageNetworkService = r.resolve(ImageNetworkService.self)
            vc.presenter.repository = r.resolve(FavoriteMoviesRepository.self)
            vc.presenter.viewController = vc
            return vc
        }
    }
}
