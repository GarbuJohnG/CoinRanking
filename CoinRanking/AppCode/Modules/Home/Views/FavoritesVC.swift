//
//  FavoritesVC.swift
//  CoinRanking
//
//  Created by John Gachuhi on 21/02/2025.
//

import UIKit
import Combine

class FavoritesVC: UIViewController {

    // MARK: - Properties
    
    var viewModel: CoinsVM!
    
    private var tableView: UITableView!
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Init
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    // MARK: - Visual Setup
    
    private func configureUI() {
        
        setupNavigationBar()
        setUpProperties()
        setupHierarchy()
        setUpAutoLayout()
        setupBindings()
        
    }
    
    private func setupNavigationBar() {
        self.title = "Favorites"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    private func setUpProperties() {
        
        tableView = UITableView()
        tableView.backgroundColor = .systemBackground
        tableView.dataSource = self
        tableView.delegate = self
        tableView.estimatedRowHeight = 80
        tableView.rowHeight = UITableView.automaticDimension
        tableView.register(CoinTableViewCell.self, forCellReuseIdentifier: CoinTableViewCell.reuseIdentifier)
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
    }
    
    private func setupHierarchy() {
        
        view.addSubview(tableView)
        
    }
    
    private func setUpAutoLayout() {
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
    }
    
    // MARK: - Other Functions and Methods
    
    private func setupBindings() {
        viewModel.$favCoins
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.tableView.reloadData()
            }
            .store(in: &cancellables)
    }
    
}

extension FavoritesVC: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.favCoins.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CoinTableViewCell.reuseIdentifier, for: indexPath) as? CoinTableViewCell else {
            return UITableViewCell()
        }
        cell.configure(with: viewModel.favCoins[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let coin = viewModel.favCoins[indexPath.row]
        let detailView = CoinDetailsVC(coin: coin)
        navigationController?.pushViewController(detailView, animated: true)
    }
    
}
