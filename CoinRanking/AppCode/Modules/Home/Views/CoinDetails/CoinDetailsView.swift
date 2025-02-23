//
//  CoinDetailsView.swift
//  CoinRanking
//
//  Created by John Gachuhi on 21/02/2025.
//

import SwiftUI

struct CoinDetailsView: View {
    
    @StateObject private var imageVM = SVGImageVM()
    
    let coinDetails: CoinDetail
    
    let targetSize = CGSize(width: 50, height: 50)

    var body: some View {
        
        ScrollView {
            
            VStack(spacing: 20) {
                
                let isPositive = (Double(coinDetails.change ?? "0") ?? 0) > 0
                
                HStack {
                    
                    VStack {
                        LazyVStack {
                            
                            if let image = imageVM.image {
                                
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
                        imageVM.loadImage(from: coinDetails.iconURL ?? "", targetSize: targetSize)
                    }

                    VStack(alignment: .leading) {
                        
                        HStack(spacing: 10) {
                            
                            Text(coinDetails.name ?? "")
                                .font(.system(size: 18, weight: .bold, design: .rounded))
                            
                            Text("#\(coinDetails.rank ?? 0)")
                                .font(.system(size: 11, weight: .regular, design: .rounded))
                                .foregroundStyle(.secondary)
                                .padding(5)
                                .background(Color.gray.opacity(0.2))
                                .cornerRadius(5)
                            
                        }
                        
                        let price = coinDetails.price ?? ""
                        
                        Text("$\(price.formatAmount())")
                            .font(.system(size: 15, weight: .medium, design: .rounded))
                            .foregroundColor(isPositive ? .green : .red)
                        
                    }
                    
                    Spacer()
                    
                }
                
                let doubleArray = coinDetails.sparkline?.compactMap { Double($0 ?? "") } ?? []
                let change = Double(coinDetails.change ?? "") ?? 0
                
                SparklineView(data: doubleArray, change: change)
                    .padding(10)
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(8)
                
                Text(coinDetails.description ?? "")
                    .font(.system(size: 15, weight: .regular, design: .rounded))
                    .foregroundStyle(.secondary)
                
                StatisticsView(coinDetails: coinDetails)
                
            }
            .padding()
        }
        .navigationTitle("\(coinDetails.symbol ?? "")")
        
    }
}

#Preview {
    CoinDetailsView(coinDetails: .bitCoinMocked)
}
