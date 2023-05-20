//
//  MovieListViewController.swift
//  movie-browser
//
//  Created by Łukasz Kudzia on 19/05/2023.
//

import UIKit
import SnapKit
import Foundation

class MovieListViewController: UIViewController {
    private let repository: FavoriteMoviesRepository = DefaultsFavoriteMoviesRepository()
    private let tableView = UITableView()
    private var movies: [MovieModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
    }
    
    private func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        view.addSubview(tableView)
        tableView.register(MovieListCell.self, forCellReuseIdentifier: "MovieListCell")
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func favoriteButtonClicked(with movieId: Int) {
        if repository.contains(movieId) {
            repository.remove(movieId)
        } else {
            repository.add(movieId)
        }
    }
    
    private func navigateToMovieDetails(_ movieId: Int) {
        // TODO: Implement Movie Details
    }
}

extension MovieListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieListCell", for: indexPath)
        
        if let movieCell = cell as? MovieListCell {
            movieCell.update(movies[indexPath.row])
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let movieId = movies[indexPath.row].id
        
        let favoriteButton = UIContextualAction(style: .normal, title: nil) { [weak self] (_, _, completionHandler) in
            self?.favoriteButtonClicked(with: movieId)
            completionHandler(true)
        }
        
        let imageName = repository.contains(movieId) ? "heart.fill" : "heart"
        favoriteButton.image = UIImage(systemName: imageName)
        favoriteButton.backgroundColor = .systemPink
        
        return UISwipeActionsConfiguration(actions: [favoriteButton])
    }
}

extension MovieListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        navigateToMovieDetails(movies[indexPath.row].id)
    }
}
