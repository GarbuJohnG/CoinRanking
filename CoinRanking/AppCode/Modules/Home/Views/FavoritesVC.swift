//
//  FavoritesVC.swift
//  CoinRanking
//
//  Created by John Gachuhi on 21/02/2025.
//

import UIKit

class FavoritesVC: UIViewController {

    // MARK: - Properties
    
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
        
    }
    
    private func setupNavigationBar() {
        self.title = "Home"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    private func setUpProperties() {
        
    }
    
    private func setupHierarchy() {
        
    }
    
    private func setUpAutoLayout() {
        
    }
    
    // MARK: - Other Functions and Methods
    
}
