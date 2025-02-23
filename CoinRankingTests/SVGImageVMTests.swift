//
//  SVGImageVMTests.swift
//  CoinRanking
//
//  Created by John Gachuhi on 23/02/2025.
//

import XCTest
import SwiftUI
@testable import CoinRanking

// MARK: - Mock ImageCacheManager for testing
class MockImageCacheManager: ImageCacheManagerProtocol {
    
    var shouldReturnError = false
    var mockImage: UIImage?
    
    func fetchImage(from urlString: String, targetSize: CGSize, completion: @escaping (UIImage?) -> Void) {
        if shouldReturnError {
            completion(nil)
        } else {
            completion(mockImage)
        }
    }
}

class SVGImageVMTests: XCTestCase {
    
    var viewModel: SVGImageVM!
    var mockCacheManager: MockImageCacheManager!
    
    override func setUp() {
        super.setUp()
        mockCacheManager = MockImageCacheManager()
        viewModel = SVGImageVM()
    }
    
    override func tearDown() {
        viewModel = nil
        mockCacheManager = nil
        super.tearDown()
    }
    
    // MARK: - Test successful image fetch and setting in ViewModel
    func testLoadImage_Success() {
        
        let expectation = XCTestExpectation(description: "Image successfully fetched and set")
        
        viewModel.loadImage(from: "https://cdn.coinranking.com/rk4RKHOuW/eth.svg", targetSize: CGSize(width: 100, height: 100))
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            XCTAssertNotNil(self.viewModel.image, "Image should not be nil")
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 2.0)
    }
    
    // MARK: - Test error handling when image fetch fails
    func testLoadImage_Failure() {
        
        mockCacheManager.shouldReturnError = true
        
        let expectation = XCTestExpectation(description: "Handle image fetch failure")
        
        viewModel.loadImage(from: "https://example.com/image.svg", targetSize: CGSize(width: 100, height: 100))
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            XCTAssertNil(self.viewModel.image, "Image should be nil on failure")
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 2.0)
    }
}

