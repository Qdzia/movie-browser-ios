//
//  ServiceFactory.swift
//  movie-browser
//
//  Created by Łukasz Kudzia on 24/05/2023.
//

import Swinject

class ServiceFactory {
    static func registerServices(in container: Container) {
        container.register(FavoriteMoviesRepository.self) { _ in DefaultsFavoriteMoviesRepository() }
            .inObjectScope(.container)
        container.register(MovieNetworkService.self) { _ in MovieNetworkService() }
            .inObjectScope(.container)
        container.register(ImageNetworkService.self) { _ in ImageNetworkService() }
            .inObjectScope(.container)
    }
}
