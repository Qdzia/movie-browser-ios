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
    private let movieNetworkService = MovieNetworkService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
        snapLayout()
        fetchMovieList()
    }
    
    private func setUpView() {
        title = "The MovieDB"
        tableView.dataSource = self
        tableView.delegate = self
        view.addSubview(tableView)
        tableView.register(MovieListCell.self, forCellReuseIdentifier: "MovieListCell")
    }
    
    private func snapLayout() {
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func fetchMovieList() {
        guard let request = movieNetworkService.nowPlayingMovies(page: 1) else { return }
        movieNetworkService.sendRequest(request) { [weak self] result in
            switch result {
            case .success(let data):
                self?.loadMovies(from: data)
            case .failure(let error):
                Log.error("Couldn't load list due to: \(error.localizedDescription)")
            }
        }
    }
    
    private func loadMovies(from data: Data) {
        guard let model: NowPlayingMoviesModel = movieNetworkService.parseJSON(data: data) else { return }
        DispatchQueue.main.async { [weak self] in
            self?.movies = model.results
            self?.tableView.reloadData()
        }
    }
    
    private func favoriteButtonClicked(with movieId: Int) {
        if repository.contains(movieId) {
            repository.remove(movieId)
        } else {
            repository.add(movieId)
        }
    }
    
    private func navigateToMovieDetails(_ movie: MovieModel) {
        let detailsViewController = MovieDetailsViewController()
        detailsViewController.update(movie)
        navigationController?.pushViewController(detailsViewController, animated: true)
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
        navigateToMovieDetails(movies[indexPath.row])
    }
}
