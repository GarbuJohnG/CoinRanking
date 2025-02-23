//
//  CoinDetailsModel.swift
//  CoinRanking
//
//  Created by John Gachuhi on 21/02/2025.
//

import Foundation

// MARK: - CoinDetailsModel
struct CoinDetailsModel: Codable {
    let status: String?
    let data: DetailDataClass?
}

// MARK: - DetailDataClass
struct DetailDataClass: Codable {
    let coin: CoinDetail?
}

// MARK: - Coin
struct CoinDetail: Codable {
    let uuid, symbol, name, description: String?
    let color: String?
    let iconURL: String?
    let websiteURL: String?
    let links: [Link]?
    let supply: Supply?
    let numberOfMarkets, numberOfExchanges: Int?
    let the24HVolume, marketCap, fullyDilutedMarketCap, price: String?
    let btcPrice: String?
    let priceAt: Int?
    let change: String?
    let rank: Int?
    let sparkline: [String?]?
    let allTimeHigh: AllTimeHigh?
    let coinrankingURL: String?
    let tier: Int?
    let lowVolume: Bool?
    let listedAt: Int?
    let hasContent: Bool?
    let contractAddresses, tags: [String]?

    enum CodingKeys: String, CodingKey {
        case uuid, symbol, name, description, color
        case iconURL = "iconUrl"
        case websiteURL = "websiteUrl"
        case links, supply, numberOfMarkets, numberOfExchanges
        case the24HVolume = "24hVolume"
        case marketCap, fullyDilutedMarketCap, price, btcPrice, priceAt, change, rank, sparkline, allTimeHigh
        case coinrankingURL = "coinrankingUrl"
        case tier, lowVolume, listedAt, hasContent, contractAddresses, tags
    }
}

// MARK: - AllTimeHigh
struct AllTimeHigh: Codable {
    let price: String?
    let timestamp: Int?
}

// MARK: - Link
struct Link: Codable {
    let name: String?
    let url: String?
    let type: String?
}

// MARK: - Supply
struct Supply: Codable {
    let confirmed: Bool?
    let supplyAt: Int?
    let max, total, circulating: String?
}

extension CoinDetail {
    static let bitCoinMocked = CoinDetail(uuid: "Qwsogvtv82FCd",
                                          symbol: "BTC",
                                          name: "Bitcoin",
                                          description: "Bitcoin is a digital currency with a finite supply, allowing users to send/receive money without a central bank/government, often nicknamed \"Digital Gold\".",
                                          color: "#f7931A",
                                          iconURL: "https://cdn.coinranking.com/bOabBYkcX/bitcoin_btc.svg",
                                          websiteURL: "https://bitcoin.org",
                                          links: [],
                                          supply: Supply(confirmed: true, supplyAt: 1740154561, max: "21000000", total: "19827278", circulating: "19827278"),
                                          numberOfMarkets: 2076,
                                          numberOfExchanges: 96,
                                          the24HVolume: "32881242300",
                                          marketCap: "1950854860889",
                                          fullyDilutedMarketCap: "2066241875393",
                                          price: "98392.47025682004",
                                          btcPrice: "1",
                                          priceAt: 1740154500,
                                          change: "0.97",
                                          rank: 1, sparkline: [
                                            "97535.48361671313",
                                            "97861.0575823266",
                                            "98247.65642276985",
                                            "98418.80656441682",
                                            "98544.25856105641",
                                            "98271.14217640103",
                                            "98214.28633475653",
                                            "98362.328534567",
                                            "98351.89486489914",
                                            "98249.69967250802",
                                            "98304.27162888189",
                                            "98208.77825876347",
                                            "98241.08906645776",
                                            "98310.30286530688",
                                            "98409.2353999796",
                                            "98413.13427325402",
                                            "98236.49590709567",
                                            "98406.1714715987",
                                            "98490.04647900996",
                                            "98698.01002220846",
                                            "98810.3522101565",
                                            "99277.91217074514",
                                            "98997.44051793763",
                                            nil
                                        ],
                                          allTimeHigh: AllTimeHigh(price: "108912.02046606789", timestamp: 1737364200),
                                          coinrankingURL: "https://coinranking.com/coin/Qwsogvtv82FCd+bitcoin-btc",
                                          tier: 1,
                                          lowVolume: false,
                                          listedAt: 1330214400,
                                          hasContent: true,
                                          contractAddresses: [
                                            "okt-chain/0x54e4622dc504176b3bb432dccaf504569699a7ff"
                                          ],
                                          tags: [
                                            "layer-1",
                                            "proof-of-work",
                                            "halal"
                                          ])
}
