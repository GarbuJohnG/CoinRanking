//
//  CoinsVM.swift
//  CoinRanking
//
//  Created by John Gachuhi on 21/02/2025.
//

import Foundation

class CoinsVM: ObservableObject {
    
    // MARK: - Published Variables
    
    @Published var coins: [Coin] = []
    @Published var isFetching = false
    @Published var error: String?
    
    // MARK: - Private Variables and Constants
    
    private let coinService: CoinServiceProtocol
    private let limit = 20
    private var offset = 0
    let maxCoins = 100

    init(coinService: CoinServiceProtocol = CoinService()) {
        self.coinService = coinService
    }

    func fetchCoins() {
        
        guard !isFetching, coins.count < maxCoins else {
            print(isFetching ? "Currently fetching more coins" : "Max coins have been fetched")
            if coins.count == maxCoins {
                error = "Max coins have been fetched"
            }
            return
        }
        
        isFetching = true
        
        let urlString = "\(Constants.URLs.baseUrl)/coins/?limit=\(limit)&offset=\(offset)"
        
        coinService.fetchCoins(urlStr: urlString) { [weak self] result in
            
            guard let self = self else { return }
            self.isFetching = false
            
            switch result {
            case .success(let response):
                self.coins.append(contentsOf: response.data?.coins ?? [])
                self.offset += self.limit
            case .failure(let error):
                print("Error fetching coins: \(error.localizedDescription)")
                self.error = "Error fetching coins: \(error.localizedDescription)"
            }
            
        }
        
    }
    
}

