//
//  CoinTableViewCell.swift
//  CoinRanking
//
//  Created by John Gachuhi on 21/02/2025.
//

import UIKit
import SwiftUI

class CoinTableViewCell: UITableViewCell {
    
    static let reuseIdentifier = "CoinCell"

    func configure(with coin: Coin) {
        let content = UIHostingConfiguration {
            CoinsCell(coin: coin)
        }
        self.contentConfiguration = content
    }
    
}
