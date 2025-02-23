//
//  StatisticsView.swift
//  CoinRanking
//
//  Created by John Gachuhi on 23/02/2025.
//

import SwiftUI

struct StatisticsView: View {
    
    @StateObject private var viewModel: StatisticsVM
    
    init(coinDetails: CoinDetail) {
        _viewModel = StateObject(wrappedValue: StatisticsVM(coinDetails: coinDetails))
    }
    
    let columns = [
        GridItem(.flexible(), spacing: 20),
        GridItem(.flexible(), spacing: 20)
    ]
    
    var body: some View {
        ScrollView {
            Text("\(viewModel.coinDetails.symbol?.uppercased() ?? "") Stats")
                .font(.system(size: 18, weight: .bold, design: .rounded))
                .frame(maxWidth: .infinity, alignment: .leading)
            
            LazyVGrid(columns: columns, spacing: 20) {
                ForEach(statisticItems, id: \.title) { item in
                    StatisticItem(title: item.title, value: item.value)
                }
            }
        }
    }
    
    // MARK: - Statistic items
    private var statisticItems: [StatisticItemData] {
        [
            StatisticItemData(title: "Mkt Cap", value: "$\(viewModel.coinDetails.marketCap?.formatLargeNumbers() ?? "N/A")"),
            StatisticItemData(title: "Volume", value: "$\(viewModel.coinDetails.the24HVolume?.formatLargeNumbers() ?? "N/A")"),
            StatisticItemData(title: "All Time High", value: "$\(viewModel.coinDetails.allTimeHigh?.price?.formatLargeNumbers() ?? "N/A")"),
            StatisticItemData(title: "Exchange Listings", value: "\(viewModel.coinDetails.numberOfExchanges ?? 0)"),
            StatisticItemData(title: "Circulating Supply", value: viewModel.coinDetails.supply?.circulating?.formatLargeNumbers() ?? "N/A"),
            StatisticItemData(title: "Total Supply", value: viewModel.coinDetails.supply?.total?.formatLargeNumbers() ?? "N/A"),
            StatisticItemData(title: "Max Supply", value: viewModel.coinDetails.supply?.max?.formatLargeNumbers() ?? "N/A"),
            StatisticItemData(title: "Markets", value: "\(viewModel.coinDetails.numberOfMarkets ?? 0)"),
            StatisticItemData(title: "Fully Diluted Value", value: viewModel.coinDetails.fullyDilutedMarketCap?.formatLargeNumbers() ?? "N/A"),
            StatisticItemData(title: "Price in BTC", value: "\(viewModel.coinDetails.btcPrice?.formatMultiDecimalNumbers() ?? "N/A") BTC"),
            StatisticItemData(title: "% \(viewModel.coinDetails.symbol?.uppercased() ?? "N/A") in circulation", value: "\(viewModel.calculatePercentCirculating()) %"),
            StatisticItemData(title: "Listing date", value: viewModel.getDateListed())
        ]
    }
}

// MARK: - StatisticItem View

struct StatisticItem: View {
    let title: String
    let value: String
    
    var body: some View {
        HStack(spacing: 5) {
            Text(title)
                .font(.system(size: 11, weight: .regular, design: .rounded))
                .foregroundStyle(.secondary)
            
            Spacer()
            
            Text(value)
                .font(.system(size: 11, weight: .medium, design: .rounded))
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

#Preview {
    StatisticsView(coinDetails: .bitCoinMocked)
}
