//
//  SVGImageVM.swift
//  CoinRanking
//
//  Created by John Gachuhi on 21/02/2025.
//

import SwiftUI

class SVGImageVM: ObservableObject {
    
    @Published var image: UIImage? = nil
    
    func loadImage(from urlString: String, targetSize: CGSize) {
        ImageCacheManager.shared.fetchImage(from: urlString, targetSize: targetSize) { fetchedImage in
            DispatchQueue.main.async {
                self.image = fetchedImage
            }
        }
    }
    
}
