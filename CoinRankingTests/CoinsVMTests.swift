//
//  CoinsVMTests.swift
//  CoinRanking
//
//  Created by John Gachuhi on 23/02/2025.
//

import XCTest
import Combine
@testable import CoinRanking

class CoinsVMTests: XCTestCase {
    
    var coinsVM: CoinsVM!
    var coinResultsVM: CoinDetailsVM!
    var mockCoinService: MockCoinService!
    var mockFavoritesService: MockFavoritesService!
    var cancellables: Set<AnyCancellable> = []
    
    override func setUp() {
        super.setUp()
        mockCoinService = MockCoinService()
        mockFavoritesService = MockFavoritesService()
        coinsVM = CoinsVM(coinService: mockCoinService, favoritesService: mockFavoritesService)
        coinResultsVM = CoinDetailsVM(coin: .bitCoinMocked, coinService: mockCoinService)
    }
    
    override func tearDown() {
        coinsVM = nil
        mockCoinService = nil
        mockFavoritesService = nil
        cancellables.removeAll()
        super.tearDown()
    }
    
    // MARK: - Test Fetching Coins
    
    func testFetchCoins_Success() {
        
        let expectedCoins = [Coin.bitCoinMocked, Coin.etheriumMocked]
        mockCoinService.coinResult = .success(CoinsModel(status: "success", data: DataClass(stats: nil, coins: expectedCoins), type: nil, message: nil))
        
        let expectation = XCTestExpectation(description: "Coins should be fetched successfully")
        
        coinsVM.$coins
            .dropFirst()
            .sink { coins in
                XCTAssertEqual(coins.count, expectedCoins.count)
                XCTAssertEqual(coins.first?.uuid, "Qwsogvtv82FCd")
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        
        coinsVM.fetchCoins()
        
        wait(for: [expectation], timeout: 1.0)
        
    }
    
    func testFetchCoins_Failure() {
        
        mockCoinService.coinResult = .failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Network error"]))
        
        let expectation = XCTestExpectation(description: "Fetching coins should fail")
        
        coinsVM.$error
            .dropFirst()
            .sink { errorMessage in
                XCTAssertNotNil(errorMessage)
                XCTAssertEqual(errorMessage, "Error fetching coins: Network error")
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        coinsVM.fetchCoins()
        
        wait(for: [expectation], timeout: 1.0)
        
    }
    
    // Test successful fetch of coin details
    func testFetchCoinDetails_Success() {
       
        let expectedCoinDetails = CoinDetail.bitCoinMocked
        mockCoinService.coinDetailsResult = .success(CoinDetailsModel(status: "success", data: DetailDataClass(coin: expectedCoinDetails)))
        
        let expectation = XCTestExpectation(description: "Fetch coin details successfully")
        
        coinResultsVM.$coinDetails
            .dropFirst()
            .sink { coins in
                XCTAssertEqual(coins?.uuid ?? "", expectedCoinDetails.uuid)
                XCTAssertEqual(expectedCoinDetails.uuid, "Qwsogvtv82FCd")
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        coinResultsVM.fetchCoinDetails()
        
        wait(for: [expectation], timeout: 2.0)
    }
    
    // Test error handling when fetch fails
    func testFetchCoinDetails_Failure() {
       
        mockCoinService.coinDetailsResult = .failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Network error"]))
        
        let expectation = XCTestExpectation(description: "Fetching coin details should fail")
        
        coinResultsVM.$error
            .dropFirst()
            .sink { errorMessage in
                XCTAssertNotNil(errorMessage)
                XCTAssertEqual(errorMessage, "Error fetching coins: Network error")
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        coinResultsVM.fetchCoinDetails()
        
        wait(for: [expectation], timeout: 2.0)
    }
    
    // MARK: - Test Favorites
    
    func testToggleIsFavourite_AddsAndRemovesCoin() {
        let coinUUID = Coin.bitCoinMocked.uuid!
        
        // MARK: - Add to favorites
        
        coinsVM.toggleIsFavourite(for: coinUUID)
        XCTAssertTrue(mockFavoritesService.isFavourite(coinUUID))
        
        // MARK: - Remove from favorites
        
        coinsVM.toggleIsFavourite(for: coinUUID)
        XCTAssertFalse(mockFavoritesService.isFavourite(coinUUID))
        
    }
    
    func testUpdateFavCoins() {
        
        let coinUUID = Coin.bitCoinMocked.uuid!
        coinsVM.coins = [Coin.bitCoinMocked]
        mockFavoritesService.addToFavourites(coinUUID)
        
        
        coinsVM.updateFavCoins()
        
        
        XCTAssertEqual(coinsVM.favCoins.count, 1)
        XCTAssertEqual(coinsVM.favCoins.first?.uuid, coinUUID)
    }
    
    // MARK: - Test Sorting
    
    func testSortCoins_ByHighestPrice() {
        
        coinsVM.coins = [Coin.bitCoinMocked, Coin.etheriumMocked]
        
        coinsVM.sortCoins(isFavs: false, sortOption: .highestPrice)
        
        XCTAssertEqual(coinsVM.coins.first?.symbol, "BTC") // Bitcoin should be first as it has a higher price
        
    }
    
    func testSortCoins_ByBestPerformance() {
        
        coinsVM.coins = [Coin.etheriumMocked, Coin.bitCoinMocked]
        
        coinsVM.sortCoins(isFavs: false, sortOption: .bestPerformance)
        
        XCTAssertEqual(coinsVM.coins.first?.symbol, "BTC") // Bitcoin has a higher percentage change
        
    }
    
    func testSortCoins_ByNone() {
        
        coinsVM.coins = [Coin.etheriumMocked, Coin.bitCoinMocked] // Initially, ETH is first
        
        coinsVM.sortCoins(isFavs: false, sortOption: .none)
        
        XCTAssertEqual(coinsVM.coins.first?.symbol, "BTC") // Sorting by rank, BTC should be first
    }
}

// MARK: - Mock Services

class MockCoinService: CoinServiceProtocol {
    
    var coinResult: Result<CoinsModel, Error>?
    var coinDetailsResult: Result<CoinDetailsModel, Error>?
    
    func fetchCoins(urlStr: String, completion: @escaping (Result<CoinsModel, Error>) -> Void) {
        if let result = coinResult {
            completion(result)
        }
    }
    
    func fetchCoinDetails(urlStr: String, completion: @escaping (Result<CoinDetailsModel, any Error>) -> Void) {
        if let result = coinDetailsResult {
            completion(result)
        }
    }
    
}

// MARK: - Mock Services Protocol

class MockFavoritesService: FavoritesServiceProtocol {
    
    static let shared = MockFavoritesService()
    
    private var favoriteCoins = Set<String>()
    
    func isFavourite(_ uuid: String) -> Bool {
        return favoriteCoins.contains(uuid)
    }
    
    func allFavourites() -> [String] {
        return Array(favoriteCoins)
    }
    
    func addToFavourites(_ uuid: String) {
        favoriteCoins.insert(uuid)
    }
    
    func removeFromFavourites(_ uuid: String) {
        favoriteCoins.remove(uuid)
    }
}
