//
//  CoinsCell.swift
//  CoinRanking
//
//  Created by John Gachuhi on 21/02/2025.
//

import SwiftUI

struct CoinsCell: View {
    
    let coin: Coin
    
    @StateObject private var viewModel = SVGImageVM()
    
    let targetSize = CGSize(width: 50, height: 50)

    var body: some View {
        
        HStack(spacing: 20) {
            
            let isPositive = (Double(coin.change ?? "0") ?? 0) > 0
            
            VStack {
                LazyVStack {
                    
                    if let image = viewModel.image {
                        
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFit()
                            .frame(width: targetSize.width, height: targetSize.height)
                            .clipShape(.circle)
                            .compositingGroup()
                        
                    } else {
                        
                        ProgressView()
                            .frame(width: targetSize.width, height: targetSize.height)
                        
                    }
                }
            }
            .frame(width: targetSize.width, height: targetSize.height)
            .onAppear {
                viewModel.loadImage(from: coin.iconURL ?? "", targetSize: targetSize)
            }
            
            VStack(alignment: .leading) {
                
                HStack(spacing: 10) {
                    
                    Text(coin.name ?? "")
                        .font(.system(size: 18, weight: .bold, design: .rounded))
                    
                    Text("#\(coin.rank ?? 0)")
                        .font(.system(size: 11, weight: .regular, design: .rounded))
                        .foregroundStyle(.secondary)
                        .padding(5)
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(5)
                    
                }
                
                let price = coin.price ?? ""
                
                Text("$\(price.formatAmount())")
                    .font(.system(size: 15, weight: .medium, design: .rounded))
                    .foregroundColor(isPositive ? .green : .red)
                
            }
            
            Spacer()
            
            let doubleArray = coin.sparkline?.compactMap { Double($0 ?? "") } ?? []
            let change = Double(coin.change ?? "") ?? 0
            
            SparklineCellView(data: doubleArray, change: change)
                .padding(10)
                .background(Color.gray.opacity(0.1))
                .cornerRadius(8)
            
        }
        .frame(height: 80)
        
    }
    
}

#Preview {
    VStack(spacing: 10) {
        CoinsCell(coin: .bitCoinMocked)
        CoinsCell(coin: .etheriumMocked)
    }
    .padding(.horizontal)
}
