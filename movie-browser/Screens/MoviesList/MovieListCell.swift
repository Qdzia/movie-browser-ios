//
//  MovieListCell.swift
//  movie-browser
//
//  Created by Łukasz Kudzia on 20/05/2023.
//

import UIKit

class MovieListCell: UITableViewCell {
    private let stackView = UIStackView()
    private let titleLabel = UILabel()
    private let voteLabel = UILabel()
    private let starImageView = UIImageView()
    
    private let elementsSpacing = 16.0
    private let cellPadding = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
    private let voteLabelWidth = 30
    
    func update(_ model: MovieModel) {
        titleLabel.text = model.title
        voteLabel.text = String(model.voteAverage)
    }

    private func setUpView() {
        starImageView.image = UIImage(systemName: "star.fill")
        starImageView.tintColor = .systemYellow
        
        stackView.axis = .horizontal
        stackView.spacing = elementsSpacing
        addSubview(stackView)

        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(starImageView)
        stackView.addArrangedSubview(voteLabel)
    }

    private func snapLayout() {
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(cellPadding)
        }
        
        voteLabel.snp.makeConstraints { make in
            make.width.equalTo(voteLabelWidth)
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUpView()
        snapLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
