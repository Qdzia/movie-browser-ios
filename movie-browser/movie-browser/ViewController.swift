//
//  ViewController.swift
//  movie-browser
//
//  Created by Łukasz Kudzia on 18/05/2023.
//

import UIKit
import SnapKit

class ViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let homeLabel = UILabel(frame: .zero)
        homeLabel.text = "Home Screen"
        homeLabel.textAlignment = .center
        view.addSubview(homeLabel)
        homeLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

