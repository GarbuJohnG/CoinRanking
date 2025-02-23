//
//  StatisticsVM.swift
//  CoinRanking
//
//  Created by John Gachuhi on 23/02/2025.
//

import Foundation

class StatisticsVM: ObservableObject {
    
    let coinDetails: CoinDetail
    
    init(coinDetails: CoinDetail) {
        self.coinDetails = coinDetails
    }
    
    // MARK: - Calculate the percentage of coins in circulation
    
    func calculatePercentCirculating() -> Int {
        let circulating = Double(coinDetails.supply?.circulating ?? "0") ?? 0.0
        let total = Double(coinDetails.supply?.total ?? "0") ?? 0.0
        return Int(((circulating / total) * 100).rounded())
    }
    
    // MARK: - Format the listing date
    
    func getDateListed() -> String {
        let timestamp: TimeInterval = TimeInterval(coinDetails.listedAt ?? 0)
        let date = Date(timeIntervalSince1970: timestamp)
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        return dateFormatter.string(from: date)
    }
    
}
