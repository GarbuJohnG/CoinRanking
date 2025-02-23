//
//  CoinsVC.swift
//  CoinRanking
//
//  Created by John Gachuhi on 21/02/2025.
//

import UIKit
import Combine
import SwiftUI

class CoinsVC: UIViewController {

    // MARK: - Properties
    
    private var tableView: UITableView!
    private var loadMoreBtn: UIButton!
    private var isLoadingMore = false
    
    var viewModel: CoinsVM!
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
        
        // MARK: - Fetch Coins after setup
        
        DispatchQueue.main.async { [weak self] in
            self?.viewModel.fetchCoins()
        }
        
    }
    
    private func setupNavigationBar() {
        self.title = "Home"
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
        
        setupFooterButton()
        
        tableView.tableFooterView = createFooterView()
        
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
    
    private func setupFooterButton() {
        
        loadMoreBtn = UIButton(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 60))
        loadMoreBtn.setTitle("Load More...", for: .normal)
        loadMoreBtn.setTitleColor(UIColor.accent, for: .normal)
        loadMoreBtn.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .bold)
        loadMoreBtn.layer.cornerRadius = 8
        loadMoreBtn.addTarget(self, action: #selector(loadMoreTapped), for: .touchUpInside)
        
    }
    
    private func createFooterView() -> UIView {
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 60))
        loadMoreBtn.frame = footerView.bounds
        footerView.addSubview(loadMoreBtn)
        return footerView
    }
    
    private func updateFooterVisibility() {
        let count = viewModel.coins.count
        let shouldShowFooter = count > 0 && count < viewModel.maxCoins
        tableView.tableFooterView = shouldShowFooter ? createFooterView() : nil
    }
    
    // MARK: - Other Functions and Methods
    
    private func setupBindings() {
        
        viewModel.$coins.sink { [weak self] coins in
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3, execute: { [weak self] in
                print(coins.count)
                self?.isLoadingMore = false
                self?.loadMoreBtn.alpha = 1.0
                self?.loadMoreBtn.isEnabled = true
                self?.tableView.reloadData()
                self?.updateFooterVisibility()
            })
        }
        .store(in: &cancellables)
        
        viewModel.$error.sink { [weak self] error in
            if let error = error {
                self?.showError(error)
                self?.viewModel.error = nil
            }
        }
        .store(in: &cancellables)
        
        viewModel.$isFetching.sink { [weak self] isFetching in
            if isFetching {
                if (self?.viewModel.coins.count ?? 0) == 0 {
                    self?.createLoadingView()
                }
            } else {
                self?.removeLoadingView()
            }
        }
        .store(in: &cancellables)
        
    }
    
    func showError(_ error: String) {
        let alert = UIAlertController(title: "Error", message: error, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Okay", style: .default))
        present(alert, animated: true)
    }
    
    @objc private func loadMoreTapped() {
        loadMoreBtn.isEnabled = false
        UIView.animate(withDuration: 0.3) {
            self.loadMoreBtn.alpha = 0.5 
        }
        guard !isLoadingMore else { return }
        isLoadingMore = true
        viewModel.fetchCoins()
    }
    
}

// MARK: - UICollectionView DataSource and Delegates

extension CoinsVC: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.coins.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let coin = viewModel.coins[indexPath.row]
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CoinTableViewCell.reuseIdentifier, for: indexPath) as? CoinTableViewCell else {
            return UITableViewCell()
        }
        cell.configure(with: coin)
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let coin = viewModel.coins[indexPath.row]
        let detailView = CoinDetailsVC(coin: coin)
        navigationController?.pushViewController(detailView, animated: true)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        guard let coinUUID = viewModel.coins[indexPath.row].uuid else { return nil }

        // Swipe action to add/remove from favorites
        let favoriteAction = UIContextualAction(style: .normal, title: nil) { [weak self] (_, _, completion) in
            guard let self = self else { return }
            
            self.viewModel.toggleIsFavourite(for: coinUUID)
            
            // Reload the row to update the checkmark
            tableView.reloadRows(at: [indexPath], with: .automatic)
            completion(true)
        }
        
        // MARK: - Set action's icon and background color
        
        if viewModel.isFavourite(coinUUID) {
            favoriteAction.image = UIImage(systemName: "heart.slash.fill")
            favoriteAction.backgroundColor = UIColor.systemRed
        } else {
            favoriteAction.image = UIImage(systemName: "heart.fill")
            favoriteAction.backgroundColor = UIColor.systemGreen
        }
        
        return UISwipeActionsConfiguration(actions: [favoriteAction])
        
    }
    
}
