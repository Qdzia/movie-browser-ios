//
//  MovieDetailsViewController.swift
//  movie-browser
//
//  Created by Łukasz Kudzia on 20/05/2023.
//

import UIKit

protocol MovieDetailsViewable {
    func loadPoster(_ image: UIImage)
}

class MovieDetailsViewController: UIViewController {
    private let posterImageView = UIImageView()
    private let titleLabel = UILabel()
    private let releaseDateLabel = UILabel()
    private let overviewLabel = UILabel()
    private let stackView = UIStackView()
    private let scrollView = UIScrollView()

    private let screenPadding = UIEdgeInsets(top: 24, left: 24, bottom: 24, right: 24)
    private let elementsSpacing = 16.0
    private let posterHeight = 350.0

    var movie: MovieModel!
    var presenter: MovieDetailsPresenter!
    weak var coordinator: MovieCoordinator!
    
    private var navigationItemImageName: String {
        presenter.isMovieInFavorites(movie.id) ? "heart.fill" : "heart"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
        snapLayout()
        addNavigationItem()
        presenter.fetchPosterImage(path: movie.posterPath)
    }
    
    private func setUpView() {
        title = "Details"
        view.backgroundColor = .white
        presenter.viewController = self

        setUpLabels()
        setUpStackView()
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
        scrollView.addSubview(stackView)
        view.addSubview(scrollView)
    }
    
    private func setUpLabels() {
        titleLabel.text = movie.title
        titleLabel.textAlignment = .center
        titleLabel.textColor = .primaryText
        
        releaseDateLabel.text = movie.releaseDate
        releaseDateLabel.textAlignment = .center
        releaseDateLabel.textColor = .secondaryText
        
        overviewLabel.text = movie.overview
        overviewLabel.textColor = .primaryText
        overviewLabel.numberOfLines = .zero
        overviewLabel.lineBreakMode = .byWordWrapping
    }
    
    private func snapLayout() {
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        stackView.snp.makeConstraints { make in
            make.top.bottom.equalTo(scrollView).inset(screenPadding)
            make.leading.trailing.equalTo(view).inset(screenPadding)
        }
        
        posterImageView.snp.makeConstraints { make in
            make.height.equalTo(posterHeight)
        }
    }
    
    private func addNavigationItem() {
        let button = UIBarButtonItem(
            image: UIImage(systemName: navigationItemImageName),
            style: .plain,
            target: self,
            action: #selector(favoriteButtonClicked)
        )
        navigationItem.rightBarButtonItem = button
    }
    
    @objc private func favoriteButtonClicked() {
        presenter.toogleFavoriteMovie(movie.id)
        navigationItem.rightBarButtonItem?.image = UIImage(systemName: navigationItemImageName)
    }
}

extension MovieDetailsViewController: MovieDetailsViewable {
    func loadPoster(_ image: UIImage) {
        posterImageView.contentMode = .scaleAspectFit
        posterImageView.image = image
    }
}
