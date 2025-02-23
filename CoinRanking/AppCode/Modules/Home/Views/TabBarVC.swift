//
//  TabBarVC.swift
//  CoinRanking
//
//  Created by John Gachuhi on 21/02/2025.
//

import UIKit

class TabBarVC: UITabBarController, UITabBarControllerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        setupTabBar()
    }

    private func setupTabBar() {
        
        let coinsVC = CoinsVC()
        let favoritesVC = FavoritesVC()
        
        coinsVC.tabBarItem = UITabBarItem(title: "Home", image: UIImage(systemName: "house.fill"), tag: 0)
        favoritesVC.tabBarItem = UITabBarItem(title: "Favorites", image: UIImage(systemName: "star.fill"), tag: 1)

        self.viewControllers = [coinsVC,favoritesVC]
        
        self.title = coinsVC.title
        
    }
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        self.title = viewController.title
    }
    
}
