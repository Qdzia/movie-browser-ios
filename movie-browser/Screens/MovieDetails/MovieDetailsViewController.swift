//
//  MovieDetailsViewController.swift
//  movie-browser
//
//  Created by Łukasz Kudzia on 20/05/2023.
//

import UIKit

class MovieDetailsViewController: UIViewController {
    private let posterImageView = UIImageView()
    private let titleLabel = UILabel()
    private let releaseDateLabel = UILabel()
    private let overviewLabel = UILabel()
    private let stackView = UIStackView()
    
    private var imageNetworkService: ImageNetworkService
    private var repository: FavoriteMoviesRepository
    private let movie: MovieModel

    private let screenPadding = UIEdgeInsets(top: 24, left: 24, bottom: 24, right: 24)
    private let elementsSpacing = 16.0
    private let posterHeight = 350.0
    
    init(movie: MovieModel, imageNetworkService: ImageNetworkService, repository: FavoriteMoviesRepository) {
        self.movie = movie
        self.imageNetworkService = imageNetworkService
        self.repository = repository
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
        snapLayout()
        addNavigationItem()
        fetchPosterImage(path: movie.posterPath)
    }
    
    private func addNavigationItem() {
        let button = UIBarButtonItem(
            image: UIImage(systemName: "heart"),
            style: .plain,
            target: self,
            action: #selector(favoriteButtonClicked)
        )
        navigationItem.rightBarButtonItem = button
        updateFavoriteButton()
    }
    
    @objc private func favoriteButtonClicked() {
        repository.addOrRemove(movie.id)
        updateFavoriteButton()
    }
    
    private func updateFavoriteButton() {
        let imageName = repository.contains(movie.id) ? "heart.fill" : "heart"
        navigationItem.rightBarButtonItem?.image = UIImage(systemName: imageName)
    }
    
    private func fetchPosterImage(path: String) {
        guard let request = imageNetworkService.poster(path: path, size: .w342) else { return }
        imageNetworkService.sendRequest(request) { [weak self] result in
            switch result {
            case .success(let data):
                self?.loadPosterImage(from: data)
            case .failure(let error):
                Log.error("Couldn't load image due to: \(error.localizedDescription)")
            }
        }
    }
    
    private func loadPosterImage(from data: Data) {
        guard let image = imageNetworkService.createImage(from: data) else {
            Log.error("Couldn't create image")
            return
        }
        DispatchQueue.main.async { [weak self] in
            self?.posterImageView.image = image
        }
    }
    
    private func setUpView() {
        title = "Details"
        
        titleLabel.text = movie.title
        titleLabel.textAlignment = .center
        
        releaseDateLabel.textAlignment = .center
        
        overviewLabel.text = movie.overview
        overviewLabel.numberOfLines = .zero
        overviewLabel.lineBreakMode = .byWordWrapping
        
        releaseDateLabel.text = movie.releaseDate
        
        posterImageView.contentMode = .scaleAspectFit
        
        setUpStackView()
        view.backgroundColor = .white
    }
    
    private func snapLayout() {
        stackView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide).inset(screenPadding)
        }
        
        posterImageView.snp.makeConstraints { make in
            make.height.equalTo(posterHeight)
        }
    }
    
    private func setUpStackView() {
        stackView.axis = .vertical
        stackView.spacing = elementsSpacing
        stackView.distribution = .fill
        stackView.addArrangedSubview(posterImageView)
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(releaseDateLabel)
        stackView.addArrangedSubview(overviewLabel)
        stackView.addArrangedSubview(UIView())
        view.addSubview(stackView)
    }
}
