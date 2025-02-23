//
//  TabBarVC.swift
//  CoinRanking
//
//  Created by John Gachuhi on 21/02/2025.
//

import UIKit
import Combine

class TabBarVC: UITabBarController, UITabBarControllerDelegate {
    
    let coinsVM = CoinsVM()
    private var cancellables = Set<AnyCancellable>()
    
    private var selectedViewTag = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        setupTabBar()
    }

    private func setupTabBar() {
        
        let coinsVC = CoinsVC()
        coinsVC.viewModel = coinsVM
        coinsVC.tabBarItem = UITabBarItem(title: "Home", image: UIImage(systemName: "house.fill"), tag: 0)
        
        let favoritesVC = FavoritesVC()
        favoritesVC.viewModel = coinsVM
        favoritesVC.tabBarItem = UITabBarItem(title: "Favorites", image: UIImage(systemName: "star.fill"), tag: 1)

        self.viewControllers = [coinsVC,favoritesVC]
        
        self.title = coinsVC.title
        
        let sortButton = UIBarButtonItem(
            image: UIImage(systemName: "line.3.horizontal.decrease.circle"),
            style: .plain,
            target: self,
            action: #selector(showSortOptions)
        )
        navigationItem.rightBarButtonItem = sortButton
        
    }
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        self.title = viewController.title
        self.selectedViewTag = viewController.title == "Home" ? 0 : 1
    }
    
    @objc private func showSortOptions() {
        
        let isFavs = self.selectedViewTag == 1
        
        let alertController = UIAlertController(title: "Sort Coins", message: "Choose a sorting option", preferredStyle: .actionSheet)
        
        let noneAction = UIAlertAction(title: "None", style: .default) { [weak self] _ in
            guard let self = self else { return }
            self.coinsVM.sortCoins(isFavs: isFavs, sortOption: .none)
        }
        
        let highestPriceAction = UIAlertAction(title: "Highest Price", style: .default) { [weak self] _ in
            guard let self = self else { return }
            self.coinsVM.sortCoins(isFavs: isFavs, sortOption: .highestPrice)
        }
        
        let bestPerformanceAction = UIAlertAction(title: "Best Performance", style: .default) { [weak self] _ in
            guard let self = self else { return }
            self.coinsVM.sortCoins(isFavs: isFavs, sortOption: .bestPerformance)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        alertController.addAction(noneAction)
        alertController.addAction(highestPriceAction)
        alertController.addAction(bestPerformanceAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true)
        
    }
    
}
