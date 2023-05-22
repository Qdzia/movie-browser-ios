//
//  MovieListViewController.swift
//  movie-browser
//
//  Created by Łukasz Kudzia on 19/05/2023.
//

import UIKit
import SnapKit
import Foundation

protocol MovieListViewable {
    func loadMovies(_ movies: [MovieModel])
}

class MovieListViewController: UIViewController {
    private let tableView = UITableView()
    
    private var tableViewCells: [MovieModel] = []
    private let presenter = MovieListPresenter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
        snapLayout()
        presenter.fetchMovieList()
    }
    
    private func setUpView() {
        title = "The MovieDB"
        view.backgroundColor = .gray
        presenter.viewController = self
        addNavigationItem()
        
        tableView.register(MovieListCell.self, forCellReuseIdentifier: "MovieListCell")
        tableView.dataSource = self
        tableView.delegate = self
        view.addSubview(tableView)
    }
    
    private func snapLayout() {
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func addNavigationItem() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "heart.circle"),
            style: .plain,
            target: self,
            action: #selector(toggleFavoriteFilter)
        )
    }
    
    @objc private func toggleFavoriteFilter() {
        presenter.toggleFavoriteFilter()
    }
    
    private func favoriteButtonClicked(on movieId: Int) {
        presenter.toogleFavoriteMovie(movieId)
    }
    
    private func navigateToMovieDetails(_ movie: MovieModel) {
        // TODO: Set up DI
        let detailsViewController = MovieDetailsViewController(movie: movie)
        navigationController?.pushViewController(detailsViewController, animated: true)
    }
}

extension MovieListViewController: MovieListViewable {
    func loadMovies(_ movies: [MovieModel]) {
        tableViewCells = movies
        tableView.reloadData()
    }
}

extension MovieListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableViewCells.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieListCell", for: indexPath)
        
        if let movieCell = cell as? MovieListCell {
            movieCell.update(tableViewCells[indexPath.row])
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let movieId = tableViewCells[indexPath.row].id
        
        let favoriteButton = UIContextualAction(style: .normal, title: nil) { [weak self] (_, _, completionHandler) in
            self?.favoriteButtonClicked(on: movieId)
            completionHandler(true)
        }
        
        let imageName = presenter.isMovieInFavorites(movieId) ? "heart.fill" : "heart"
        favoriteButton.image = UIImage(systemName: imageName)
        favoriteButton.backgroundColor = .accent
        
        return UISwipeActionsConfiguration(actions: [favoriteButton])
    }
}

extension MovieListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        navigateToMovieDetails(tableViewCells[indexPath.row])
    }
}
