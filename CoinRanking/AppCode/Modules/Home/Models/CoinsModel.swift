//
//  CoinsModel.swift
//  CoinRanking
//
//  Created by John Gachuhi on 21/02/2025.
//

import Foundation

// MARK: - CoinsResponse
struct CoinsModel: Codable {
    let status: String
    let data: DataClass?
    let type, message: String?
}

// MARK: - DataClass
struct DataClass: Codable {
    let stats: Stats?
    let coins: [Coin]?
}

// MARK: - Coin
struct Coin: Codable {
    let uuid, symbol, name: String?
    let iconURL: String?
    let marketCap, price: String?
    let tier: Int?
    let change: String?
    let rank: Int?
    let sparkline: [String?]?
    
    enum CodingKeys: String, CodingKey {
        case uuid, symbol, name
        case iconURL = "iconUrl"
        case marketCap, price, tier, change, rank, sparkline
    }
}

// MARK: - Stats
struct Stats: Codable {
    let total, totalCoins, totalMarkets, totalExchanges: Int?
    let totalMarketCap, total24HVolume: String?
    
    enum CodingKeys: String, CodingKey {
        case total, totalCoins, totalMarkets, totalExchanges, totalMarketCap
        case total24HVolume = "total24hVolume"
    }
}

extension Coin {
    static let bitCoinMocked = Coin(uuid: "Qwsogvtv82FCd",
                                    symbol: "BTC",
                                    name: "Bitcoin",
                                    iconURL: "https://cdn.coinranking.com/bOabBYkcX/bitcoin_btc.svg",
                                    marketCap: "1954122628099",
                                    price: "98558.0126594903",
                                    tier: 1,
                                    change: "1.64",
                                    rank: 1,
                                    sparkline: ["96969.0256084245",
                                                "96976.94433364748",
                                                "97233.40050597143",
                                                "97247.70859485943",
                                                "97283.89540619562",
                                                "97443.53541422971",
                                                "97437.9278867871",
                                                "97711.03498704736",
                                                "97128.55298869772",
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
                                                nil])
    
    static let etheriumMocked = Coin(uuid: "razxDUgYGNAdQ",
                                     symbol: "ETH",
                                     name: "Ethereum",
                                     iconURL: "https://cdn.coinranking.com/rk4RKHOuW/eth.svg",
                                     marketCap: "333422180534",
                                     price: "2765.5756484966632",
                                     tier: 1,
                                     change: "1.38",
                                     rank: 2,
                                     sparkline: ["2730.384996729387",
                                                 "2732.9746698139043",
                                                 "2730.5252873685454",
                                                 "2736.7635639563164",
                                                 "2741.831514645426",
                                                 "2743.3781361264178",
                                                 "2741.3534634717153",
                                                 "2756.0479060728153",
                                                 "2728.362952838015",
                                                 "2721.309439801538",
                                                 "2728.3158614834574",
                                                 "2741.0811540147024",
                                                 "2750.3884488937283",
                                                 "2752.772602224958",
                                                 "2738.4295770703543",
                                                 "2730.698754371064",
                                                 "2738.460767235121",
                                                 "2740.143447493085",
                                                 "2736.3952128284927",
                                                 "2740.7273071688487",
                                                 "2743.416327374805",
                                                 "2749.16481006808",
                                                 "2751.9763203647617",
                                                 nil])
}
