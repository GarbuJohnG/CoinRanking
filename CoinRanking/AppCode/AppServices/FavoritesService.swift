//
//  FavoritesService.swift
//  CoinRanking
//
//  Created by John Gachuhi on 23/02/2025.
//

import Foundation
import SwiftUI

protocol FavoritesServiceProtocol: AnyObject {
    func addToFavourites(_ uuid: String)
    func removeFromFavourites(_ uuid: String)
    func isFavourite(_ uuid: String) -> Bool
    func allFavourites() -> [String]
}

final class FavoritesService: FavoritesServiceProtocol {
    
    static let shared = FavoritesService()
    
    private init() {}

    // MARK: - Use AppStorage to persist favourites
    
    @AppStorage("favourites") private var favouritesData: Data = Data()

    private var favourites: Set<String> {
        get {
            if let decoded = try? JSONDecoder().decode(Set<String>.self, from: favouritesData) {
                return decoded
            }
            return []
        }
        set {
            if let encoded = try? JSONEncoder().encode(newValue) {
                favouritesData = encoded
            }
        }
    }

    // MARK: - Add a favourite and save to AppStorage
    
    func addToFavourites(_ uuid: String) {
        var currentFavourites = favourites
        currentFavourites.insert(uuid)
        favourites = currentFavourites
    }

    // MARK: - Remove a favourite and save to AppStorage
    
    func removeFromFavourites(_ uuid: String) {
        var currentFavourites = favourites
        currentFavourites.remove(uuid)
        favourites = currentFavourites
    }

    // MARK: - Check if a UUID is a favourite
    
    func isFavourite(_ uuid: String) -> Bool {
        return favourites.contains(uuid)
    }

    // MARK: - Get all favourites
    
    func allFavourites() -> [String] {
        return Array(favourites)
    }
    
}
