//
//  CoinDetailsVC.swift
//  CoinRanking
//
//  Created by John Gachuhi on 21/02/2025.
//

import UIKit
import SwiftUI
import Combine

class CoinDetailsVC: UIViewController {

    // MARK: - Properties
    
    private var coin: Coin
    private var viewModel: CoinDetailsVM
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Init
    
    init(coin: Coin) {
        self.coin = coin
        viewModel = CoinDetailsVM(coin: coin)
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    // MARK: - Visual Setup
    
    private func configureUI() {
        
        setupNavigationBar()
        setUpProperties()
        setupViewModel()
        
        // MARK: - Fetch Coin Details after setup
        
        DispatchQueue.main.async { [weak self] in
            self?.viewModel.fetchCoinDetails()
        }
        
    }
    
    private func setupNavigationBar() {
        navigationItem.title = coin.symbol
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    private func setUpProperties() {
        
        self.view.backgroundColor = .systemBackground
        
    }
    
    private func setupViewModel() {
        
        viewModel.$coinDetails.sink { [weak self] coinDetails in
            if let coinDetails = coinDetails {
                self?.addCoinDetsView(coinDetails: coinDetails)
            }
        }
        .store(in: &cancellables)
        
        viewModel.$isFetching.sink { [weak self] isFetching in
            if isFetching {
                self?.createLoadingView()
            } else {
                self?.removeLoadingView()
            }
        }
        .store(in: &cancellables)
        
    }
    
    func addCoinDetsView(coinDetails: CoinDetail) {
        
        let detailsView = CoinDetailsView(coinDetails: coinDetails)
        let hostingController = UIHostingController(rootView: detailsView)
        addChild(hostingController)
        view.addSubview(hostingController.view)
        
        hostingController.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            hostingController.view.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            hostingController.view.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            hostingController.view.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            hostingController.view.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
        ])
        hostingController.didMove(toParent: self)
        
    }
    
    // MARK: - Other Functions and Methods
    
    
    
}

