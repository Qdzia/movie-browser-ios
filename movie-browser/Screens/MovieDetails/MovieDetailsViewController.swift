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
    
    private let imageNetworkService = ImageNetworkService()
    
    private let screenPadding = UIEdgeInsets(top: 24, left: 24, bottom: 24, right: 24)
    private let elementsSpacing = 16.0
    private let posterHeight = 350.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
        snapLayout()
    }
    
    func update(_ model: MovieModel) {
        titleLabel.text = model.title
        overviewLabel.text = model.overview
        releaseDateLabel.text = model.releaseDate
        fetchPosterImage(path: model.posterPath)
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
        guard let image = imageNetworkService.createImage(from: data) else { return }
        DispatchQueue.main.async { [weak self] in
            self?.posterImageView.image = image
        }
    }
    
    private func setUpView() {
        title = "Details"
        
        titleLabel.textAlignment = .center
        
        releaseDateLabel.textAlignment = .center
        
        overviewLabel.numberOfLines = .zero
        overviewLabel.lineBreakMode = .byWordWrapping
        
        posterImageView.contentMode = .scaleAspectFit
        
        stackView.axis = .vertical
        stackView.spacing = elementsSpacing
        stackView.distribution = .fill
        stackView.addArrangedSubview(posterImageView)
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(releaseDateLabel)
        stackView.addArrangedSubview(overviewLabel)
        stackView.addArrangedSubview(UIView())

        view.addSubview(stackView)
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
}
