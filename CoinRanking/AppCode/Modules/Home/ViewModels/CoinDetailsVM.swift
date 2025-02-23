//
//  CoinDetailsVM.swift
//  CoinRanking
//
//  Created by John Gachuhi on 21/02/2025.
//

import Foundation

class CoinDetailsVM: ObservableObject {
    
    // MARK: - Published Variables
    
    @Published var coinDetails: CoinDetail?
    @Published var isFetching = false
    @Published var error: String?
    
    private let coin: Coin
    
    // MARK: - Private Variables and Constants
    
    private let coinService: CoinServiceProtocol

    init(coin: Coin, coinService: CoinServiceProtocol = CoinService()) {
        self.coinService = coinService
        self.coin = coin
    }
    
    // MARK: - Fetch Coin Details

    func fetchCoinDetails() {
        
        guard !isFetching else {
            print("Currently fetching more coins")
            return
        }
        
        isFetching = true
        
        let urlString = "\(Constants.URLs.baseUrl)\(Constants.Endpoints.coinDetails)\(coin.uuid ?? "")"
        
        coinService.fetchCoinDetails(urlStr: urlString) { [weak self] result in
            
            guard let self = self else { return }
            self.isFetching = false
            
            switch result {
            case .success(let response):
                self.coinDetails = response.data?.coin
            case .failure(let error):
                print("Error fetching coins: \(error.localizedDescription)")
                self.error = "Error fetching coins: \(error.localizedDescription)"
            }
            
        }
        
    }
    
}

