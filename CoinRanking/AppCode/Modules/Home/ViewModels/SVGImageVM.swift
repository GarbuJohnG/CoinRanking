//
//  SVGImageVM.swift
//  CoinRanking
//
//  Created by John Gachuhi on 21/02/2025.
//

import SwiftUI

protocol ImageCacheManagerProtocol {
    func fetchImage(from urlString: String, targetSize: CGSize, completion: @escaping (UIImage?) -> Void)
}

class SVGImageVM: ObservableObject {
    
    @Published var image: UIImage? = nil
    private let imageCacheManager: ImageCacheManagerProtocol
    
    init(imageCacheManager: ImageCacheManagerProtocol = ImageCacheManager.shared) {
        self.imageCacheManager = imageCacheManager
    }
    
    func loadImage(from urlString: String, targetSize: CGSize) {
        imageCacheManager.fetchImage(from: urlString, targetSize: targetSize) { fetchedImage in
            DispatchQueue.main.async {
                self.image = fetchedImage
            }
        }
    }
}

extension ImageCacheManager: ImageCacheManagerProtocol {}
