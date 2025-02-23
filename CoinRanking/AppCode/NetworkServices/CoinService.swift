//
//  CoinService.swift
//  CoinRanking
//
//  Created by John Gachuhi on 21/02/2025.
//

import Foundation

protocol CoinServiceProtocol {
    func fetchCoins(urlStr: String, completion: @escaping (Result<CoinsModel, Error>) -> Void)
    func fetchCoinDetails(urlStr: String, completion: @escaping (Result<CoinDetailsModel, Error>) -> Void)
}

class CoinService: CoinServiceProtocol {
    
    // MARK: - Fetch Coins
    
    func fetchCoins(urlStr: String, completion: @escaping (Result<CoinsModel, Error>) -> Void) {
        performRequest(urlStr: urlStr, completion: completion)
    }
    
    // MARK: - Fetch Coin Details
    
    func fetchCoinDetails(urlStr: String, completion: @escaping (Result<CoinDetailsModel, Error>) -> Void) {
        performRequest(urlStr: urlStr, completion: completion)
    }
    
    // MARK: - Perform GET request
    
    private func performRequest<T: Decodable>(urlStr: String, completion: @escaping (Result<T, Error>) -> Void) {
        guard let url = URL(string: urlStr) else {
            DispatchQueue.main.async {
                completion(.failure(NSError(domain: "Invalid URL", code: 400)))
            }
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue(Constants.AppKeys.coinRankAPIKey, forHTTPHeaderField: "x-access-token")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
                return
            }
            
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(.failure(NSError(domain: "No data has been received", code: 204)))
                }
                return
            }
            
            do {
                let decodedData = try JSONDecoder().decode(T.self, from: data)
                DispatchQueue.main.async {
                    completion(.success(decodedData))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }.resume()
    }
    
}
