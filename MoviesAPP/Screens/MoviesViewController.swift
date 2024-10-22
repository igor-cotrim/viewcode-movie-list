//
//  MoviesViewController.swift
//  MoviesAPP
//
//  Created by Karolina Attekita on 28/03/22.
//

import UIKit

final class MoviesViewController: UIViewController {
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "background")
        imageView.contentMode = .scaleToFill
        imageView.alpha = 0.4
        
        return imageView
    }()
    
    private lazy var searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
        
        searchController.searchBar.tintColor = .white
        searchController.searchBar.barStyle = .black
        searchController.searchBar.delegate = self
        
        return searchController
    }()
    
    private var movies: [Movie]? {
        didSet {
            tableView.reloadData()
        }
    }
    private let service: MoviesService = MoviesService()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .clear
        tableView.dataSource = self
        tableView.rowHeight = 150
        tableView.estimatedRowHeight = 150
        tableView.registerCell(type: MovieCell.self)
        
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        fetchMovies()
    }
    
    private func fetchMovies() {
        service.fetchList { [weak self] result in
            switch result {
            case .success(let response):
                self?.movies = response
            case .failure:
                self?.movies = nil
            }
        }
    }
    
    private func searchhMovies(term: String) {
        service.fetchResults(term) { [weak self] result in
            switch result {
            case .success(let response):
                self?.movies = response.compactMap({ $0.show })
            case .failure:
                self?.movies = nil
            }
        }
    }
    
    private func setupNavigation() {
        title = "My movies"
        navigationController?.navigationBar.prefersLargeTitles = true
        let textAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        navigationController?.navigationBar.largeTitleTextAttributes = textAttributes
        navigationItem.searchController = searchController
    }
}

// MARK: - TableView DataSource
extension MoviesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let movieCell = tableView.dequeueCell(
            withType: MovieCell.self,
            for: indexPath
        ) as? MovieCell
        
        if let model = movies?[indexPath.row] {
            movieCell?.configure(model: model)
        }
        
        return movieCell ?? UITableViewCell()
    }
}

// MARK: - ViewCode
extension MoviesViewController: ViewCode {
    func buildHierarchy() {
        view.addSubview(imageView)
        view.addSubview(tableView)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: view.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
    }
    
    func applyAdditionalChanges() {
        setupNavigation()
    }
}

// MARK: - Search Bar
extension MoviesViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard !searchText.isEmpty else {
            fetchMovies()
            return
        }
        searchhMovies(term: searchText)
    }
}
