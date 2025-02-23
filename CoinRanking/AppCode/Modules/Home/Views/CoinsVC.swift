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
    private var footerButton: UIButton!
    private var isLoadingMore = false
    
    private var viewModel = CoinsVM()
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
        setupViewModel()
        
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
        
        footerButton = UIButton(type: .system)
        footerButton.setTitle("Load More", for: .normal)
        footerButton.setTitleColor(.white, for: .normal)
        footerButton.backgroundColor = .systemBlue
        footerButton.layer.cornerRadius = 10
        footerButton.addTarget(self, action: #selector(loadMoreTapped), for: .touchUpInside)
        
        tableView = UITableView()
        tableView.backgroundColor = .systemBackground
        tableView.dataSource = self
        tableView.delegate = self
        tableView.estimatedRowHeight = 80
        tableView.rowHeight = UITableView.automaticDimension
        tableView.register(CoinTableViewCell.self, forCellReuseIdentifier: CoinTableViewCell.reuseIdentifier)
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        footerButton.isHidden = true
        
    }
    
    private func setupHierarchy() {
        
        view.addSubview(tableView)
        tableView.tableFooterView = createFooterView()
        
    }
    
    private func setUpAutoLayout() {
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
    }
    
    private func createFooterView() -> UIView {
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 50))
        footerButton.frame = footerView.bounds
        footerButton.center = footerView.center
        footerView.addSubview(footerButton)
        return footerView
    }
    
    // MARK: - Other Functions and Methods
    
    private func setupViewModel() {
        
        viewModel.$coins.sink { [weak self] coins in
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3, execute: { [weak self] in
                print(coins.count)
                self?.isLoadingMore = false
                if coins.count > 0 && coins.count < (self?.viewModel.maxCoins ?? 0) {
                    self?.footerButton.isHidden = false
                    UIView.animate(withDuration: 0.3) {
                        self?.footerButton.alpha = 1.0
                        self?.footerButton.isEnabled = true
                    }
                } else {
                    UIView.animate(withDuration: 0.3) {
                        self?.footerButton.alpha = 0.0
                        self?.footerButton.isEnabled = false
                    }
                    self?.footerButton.isHidden = true
                }
                self?.tableView.reloadData()
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
        guard !isLoadingMore else { return }
        
        isLoadingMore = true
        
        // Animate fade effect
        UIView.animate(withDuration: 0.3) {
            self.footerButton.alpha = 0.5
        }
        
        footerButton.isEnabled = false
        
        viewModel.fetchCoins()
    }
    
}

// MARK: - UICollectionView DataSource and Delegates

extension CoinsVC: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.coins.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CoinTableViewCell.reuseIdentifier, for: indexPath) as? CoinTableViewCell else {
            return UITableViewCell()
        }
        cell.configure(with: viewModel.coins[indexPath.row])
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let coin = viewModel.coins[indexPath.row]
        let detailView = CoinDetailsVC(coin: coin)
        navigationController?.pushViewController(detailView, animated: true)
    }
    
}
