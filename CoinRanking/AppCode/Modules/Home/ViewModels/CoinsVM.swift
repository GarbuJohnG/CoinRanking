//
//  CoinsVM.swift
//  CoinRanking
//
//  Created by John Gachuhi on 21/02/2025.
//

import Foundation

enum SortOptions {
    case none
    case highestPrice
    case bestPerformance
}

class CoinsVM: ObservableObject {
    
    // MARK: - Published Variables
    
    @Published var coins: [Coin] = []
    @Published var favCoins: [Coin] = []
    @Published var isFetching = false
    @Published var error: String?
    
    // MARK: - Private Variables and Constants
    
    private let coinService: CoinServiceProtocol
    private let favoritesService: FavoritesServiceProtocol
    private let limit = 20
    private var offset = 0
    let maxCoins = 100

    init(coinService: CoinServiceProtocol = CoinService(), favoritesService: FavoritesServiceProtocol = FavoritesService.shared) {
        self.coinService = coinService
        self.favoritesService = favoritesService
    }
    
    // MARK: - Fetch Coins

    func fetchCoins() {
        
        guard !isFetching, coins.count < maxCoins else {
            print(isFetching ? "Currently fetching more coins" : "Max coins have been fetched")
            if coins.count == maxCoins {
                error = "Max coins have been fetched"
            }
            return
        }
        
        isFetching = true
        
        let urlString = "\(Constants.URLs.baseUrl)\(Constants.Endpoints.listCoins)?limit=\(limit)&offset=\(offset)"
        
        coinService.fetchCoins(urlStr: urlString) { [weak self] result in
            
            guard let self = self else { return }
            self.isFetching = false
            
            switch result {
            case .success(let response):
                self.coins.append(contentsOf: response.data?.coins ?? [])
                self.offset += self.limit
                self.updateFavCoins()
            case .failure(let error):
                print("Error fetching coins: \(error.localizedDescription)")
                self.error = "Error fetching coins: \(error.localizedDescription)"
            }
            
        }
        
    }
    
    // MARK: - Toggle between is and is not favorite
    
    func toggleIsFavourite(for uuid: String) {
        if favoritesService.isFavourite(uuid) {
            favoritesService.removeFromFavourites(uuid)
        } else {
            favoritesService.addToFavourites(uuid)
        }
        updateFavCoins()
    }
    
    // MARK: - Check if is favorite

    func isFavourite(_ uuid: String) -> Bool {
        return favoritesService.isFavourite(uuid)
    }
    
    // MARK: - Update FavCoins Changes
    
    func updateFavCoins() {
        favCoins = coins.filter { isFavourite($0.uuid ?? "") }
    }
    
    // MARK: - Sort Coins
    
    func sortCoins(isFavs: Bool, sortOption: SortOptions) {
        switch sortOption {
        case .none:
            if isFavs {
                favCoins.sort { ($0.rank ?? 0) < ($1.rank ?? 0) }
            } else {
                coins.sort { ($0.rank ?? 0) < ($1.rank ?? 0) }
            }
        case .highestPrice:
            if isFavs {
                favCoins.sort {
                    Double($0.price ?? "0") ?? 0 > Double($1.price ?? "0") ?? 0
                }
            } else {
                coins.sort {
                    Double($0.price ?? "0") ?? 0 > Double($1.price ?? "0") ?? 0
                }
            }
        case .bestPerformance:
            if isFavs {
                favCoins.sort {
                    Double($0.change ?? "0") ?? 0 > Double($1.change ?? "0") ?? 0
                }
            } else {
                coins.sort {
                    Double($0.change ?? "0") ?? 0 > Double($1.change ?? "0") ?? 0
                }
            }
        }
    }
    
}

