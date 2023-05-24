//
//  MovieCoordinator.swift
//  movie-browser
//
//  Created by Łukasz Kudzia on 23/05/2023.
//

import UIKit
import Swinject

class MovieCoordinator: Coordinator {
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController
    let container = Container()
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.navigationController.navigationBar.tintColor = .accent
        ServiceFactory.registerServices(in: container)
        ScreenFactory.registerScreens(in: container)
    }
    
    func start() {
        let viewController = container.resolve(MovieListViewController.self)!
        viewController.coordinator = self
        navigationController.viewControllers = [viewController]
    }
    
    func navigateToMovieDetails(_ movie: MovieModel?) {
        let viewController = container.resolve(MovieDetailsViewController.self, argument: movie)!
        viewController.coordinator = self
        navigationController.pushViewController(viewController, animated: true)
    }
}
