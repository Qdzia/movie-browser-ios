//
//  Coordinator.swift
//  movie-browser
//
//  Created by Łukasz Kudzia on 23/05/2023.
//

import UIKit

protocol Coordinator {
    var childCoordinators: [Coordinator] { get set }
    var navigationController: UINavigationController { get set }
    
    func start()
}
