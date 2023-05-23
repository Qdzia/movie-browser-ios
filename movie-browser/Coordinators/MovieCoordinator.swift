//
//  MovieCoordinator.swift
//  movie-browser
//
//  Created by Łukasz Kudzia on 23/05/2023.
//

import UIKit

class MovieCoordinator: Coordinator {
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController
    
    private let favoriteRepository = DefaultsFavoriteMoviesRepository()
    private let movieNetworkingService = MovieNetworkService()
    private let imageNetworkService = ImageNetworkService()

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.navigationController.navigationBar.tintColor = .accent
    }

    func start() {
        let presenter = MovieListPresenter(
            movieNetworkService: movieNetworkingService,
            repository: favoriteRepository
        )
        let viewController = MovieListViewController()
        viewController.coordinator = self
        viewController.presenter = presenter
        presenter.viewController = viewController
        navigationController.viewControllers = [viewController]
    }
    
    func navigateToMovieDetails(_ movie: MovieModel) {
        let presenter = MovieDetailsPresenter(
            imageNetworkService: imageNetworkService,
            repository: favoriteRepository
        )
        let viewController = MovieDetailsViewController(movie: movie)
        viewController.coordinator = self
        viewController.presenter = presenter
        presenter.viewController = viewController
        navigationController.pushViewController(viewController, animated: true)
    }
}
