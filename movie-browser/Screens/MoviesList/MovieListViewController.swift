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
    let moviesTableView = UITableView()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
    }
    
    func setupTableView() {
        view.addSubview(moviesTableView)
        moviesTableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
