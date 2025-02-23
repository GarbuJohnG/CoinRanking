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
    let contractAddresses: [String]?

    enum CodingKeys: String, CodingKey {
        case uuid, symbol, name, description, color
        case iconURL = "iconUrl"
        case websiteURL = "websiteUrl"
        case links, supply, numberOfMarkets, numberOfExchanges
        case the24HVolume = "24hVolume"
        case marketCap, fullyDilutedMarketCap, price, btcPrice, priceAt, change, rank, sparkline, allTimeHigh
        case coinrankingURL = "coinrankingUrl"
        case tier, lowVolume, listedAt, hasContent, contractAddresses
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
                                          ])
    
    static let etheriumMocked = CoinDetail(uuid: "razxDUgYGNAdQ",
                                           symbol: "ETH",
                                           name: "Etherium",
                                           description: "Ethereum is a global, public decentralized blockchain designed to run peer-to-peer smart contracts and decentralized applications.",
                                           color: "#3C3C3D",
                                           iconURL: "https://cdn.coinranking.com/rk4RKHOuW/eth.svg",
                                           websiteURL: "https://www.ethereum.org",
                                           links: [
                                            Link(name: "www.ethereum.org",
                                                 url: "https://www.ethereum.org",
                                                 type: "website"),
                                            Link(name: "etherscan.io",
                                                 url: "https://etherscan.io/",
                                                 type: "website"),
                                            Link(name: "bitcointalk.org",
                                                 url: "https://bitcointalk.org/index.php?topic=428589.0",
                                                 type: "bitcointalk"),
                                            Link(name: "ethereumproject",
                                                 url: "https://facebook.com/ethereumproject",
                                                 type: "facebook"),
                                            Link(name: "ethereum",
                                                 url: "https://github.com/ethereum",
                                                 type: "github"),
                                            Link(name: "ethereum",
                                                 url: "https://www.reddit.com/r/ethereum/",
                                                 type: "reddit"),
                                            Link(name: "ethtrader",
                                                 url: "https://www.reddit.com/r/ethtrader/",
                                                 type: "reddit"),
                                            Link(name: "@ethereum",
                                                 url: "https://twitter.com/ethereum",
                                                 type: "twitter"),
                                            Link(name: "YouTube",
                                                 url: "https://www.youtube.com/channel/UCNOfzGXD_C9YMYmnefmPH0g",
                                                 type: "youtube")
                                           ],
                                           supply: Supply(confirmed: true, supplyAt: 1740326408, max: nil, total: "120568910.11267465", circulating: "120568910.11267465"),
                                           numberOfMarkets: 1471,
                                           numberOfExchanges: 92,
                                           the24HVolume: "14121997460",
                                           marketCap: "337817521792",
                                           fullyDilutedMarketCap: "337817521792",
                                           price: "2801.862615135362",
                                           btcPrice: "0.02932861484998847",
                                           priceAt: 1740327840,
                                           change: "0.88",
                                           rank: 2,
                                           sparkline: [
                                            "2781.456003327358",
                                            "2785.9573831375214",
                                            "2779.285845602352",
                                            "2766.899028978449",
                                            "2768.894358638882",
                                            "2770.2792033482015",
                                            "2770.6977366900933",
                                            "2768.2141892881723",
                                            "2761.753561512477",
                                            "2766.989955449202",
                                            "2760.753484963609",
                                            "2753.9790907464712",
                                            "2754.259379878762",
                                            "2776.0228474660007",
                                            "2788.203456087401",
                                            "2811.1831528427783",
                                            "2816.5995942897093",
                                            "2804.3695013275783",
                                            "2808.6152171473095",
                                            "2801.713530724812",
                                            "2793.3962212169326",
                                            "2808.539960396304",
                                            "2803.6391749206655",
                                            nil
                                           ], allTimeHigh: AllTimeHigh(price: "4896.8770886838465", timestamp: 1636502400),
                                           coinrankingURL: "https://coinranking.com/coin/razxDUgYGNAdQ+ethereum-eth",
                                           tier: 1,
                                           lowVolume: false,
                                           listedAt: 1438905600,
                                           hasContent: true,
                                           contractAddresses: [
                                            "solana/2FPyTwcZLUg1MDrwsyoP4D6s1tM7hAkHYRjkNb5w6Pxk",
                                            "starknet/0x49d36570d4e46f48e99674bd3fcc84644ddd6b96f7c741b1562b82f9e004dc7",
                                            "mantle/0xdEAddEaDdeadDEadDEADDEAddEADDEAddead1111",
                                            "zksync/0x000000000000000000000000000000000000800a",
                                            "optimism/ ",
                                            "starknet/0x049d36570d4e46f48e99674bd3fcc84644ddd6b96f7c741b1562b82f9e004dc7",
                                            "okt-chain/0xef71ca2ee68f45b9ad6f72fbdb33d707b872315c"
                                           ])
}
