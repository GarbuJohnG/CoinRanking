//
//  SVGImageService.swift
//  CoinRanking
//
//  Created by John Gachuhi on 21/02/2025.
//

import UIKit
import SVGKit

class ImageCacheManager {
    
    static let shared = ImageCacheManager()
    private let memoryCache = NSCache<NSString, UIImage>()
    private let fileManager = FileManager.default
    private let cacheDirectory: URL
    private let maxDiskCacheSize: Int = 150 * 1024 * 1024 // 150 MB
    
    private init() {
        // MARK: - Create a dedicated directory for the cache
        
        let directories = fileManager.urls(for: .cachesDirectory, in: .userDomainMask)
        cacheDirectory = directories[0].appendingPathComponent("ImageCache")
        createCacheDirectoryIfNeeded()
        
    }
    
    // MARK: - Public Methods
    
    func fetchImage(from urlString: String, targetSize: CGSize, completion: @escaping (UIImage?) -> Void) {
        
        let cacheKey = cacheKey(for: urlString, targetSize: targetSize)
        
        // MARK: - Check in-memory cache first
        if let cachedImage = memoryCache.object(forKey: cacheKey as NSString) {
            completion(cachedImage)
            return
        }
        
        // MARK: - Check disk cache
        if let diskImage = loadImageFromDisk(with: cacheKey) {
            memoryCache.setObject(diskImage, forKey: cacheKey as NSString)
            completion(diskImage)
            return
        }
        
        // MARK: - Download and resize the image on a background thread
        DispatchQueue.global(qos: .userInitiated).async {
            guard let url = URL(string: urlString),
                  let data = try? Data(contentsOf: url) else {
                DispatchQueue.main.async {
                    completion(nil)
                }
                return
            }
            
            var image: UIImage?
            
            if urlString.lowercased().hasSuffix(".svg") {
                // Process as SVG image
                if let svgImage = SVGKImage(data: data)?.uiImage {
                    image = svgImage
                }
            } else {
                // Process as normal UIImage
                image = UIImage(data: data)
            }
            
            guard let resizedImage = image.flatMap({ self.resizeImage(image: $0, targetSize: targetSize) }) else {
                DispatchQueue.main.async {
                    completion(nil)
                }
                return
            }
            
            // MARK: - Save to memory and disk cache
            self.memoryCache.setObject(resizedImage, forKey: cacheKey as NSString)
            self.saveImageToDisk(image: resizedImage, with: cacheKey)
            
            DispatchQueue.main.async {
                completion(resizedImage)
            }
        }
    
    }
    
    // MARK: - Private Methods
    
    private func cacheKey(for urlString: String, targetSize: CGSize) -> String {
        return "\(urlString)_\(targetSize.width)x\(targetSize.height)"
    }
    
    private func createCacheDirectoryIfNeeded() {
        if !fileManager.fileExists(atPath: cacheDirectory.path) {
            try? fileManager.createDirectory(at: cacheDirectory, withIntermediateDirectories: true, attributes: nil)
        }
    }
    
    private func saveImageToDisk(image: UIImage, with key: String) {
        let fileURL = cacheDirectory.appendingPathComponent(key)
        if let data = image.pngData() {
            try? data.write(to: fileURL)
            enforceDiskCacheSizeLimit()
        }
    }
    
    private func loadImageFromDisk(with key: String) -> UIImage? {
        let fileURL = cacheDirectory.appendingPathComponent(key)
        if let data = try? Data(contentsOf: fileURL) {
            return UIImage(data: data)
        }
        return nil
    }
    
    private func enforceDiskCacheSizeLimit() {
        DispatchQueue.global(qos: .utility).async {
            let contents = (try? self.fileManager.contentsOfDirectory(at: self.cacheDirectory, includingPropertiesForKeys: [.contentModificationDateKey], options: .skipsHiddenFiles)) ?? []
            let filesWithAttributes = contents.compactMap { url -> (URL, Date)? in
                if let attributes = try? self.fileManager.attributesOfItem(atPath: url.path),
                   let modificationDate = attributes[.modificationDate] as? Date {
                    return (url, modificationDate)
                }
                return nil
            }
            
            // MARK: - Sort files by modification date (oldest first)
            
            let sortedFiles = filesWithAttributes.sorted { $0.1 < $1.1 }.map { $0.0 }
            
            // MARK: - Calculate total size and remove oldest files if necessary
            
            var totalSize = sortedFiles.reduce(0) { size, fileURL in
                if let attributes = try? self.fileManager.attributesOfItem(atPath: fileURL.path),
                   let fileSize = attributes[.size] as? Int {
                    return size + fileSize
                }
                return size
            }
            
            while totalSize > self.maxDiskCacheSize, let oldestFile = sortedFiles.first {
                if let attributes = try? self.fileManager.attributesOfItem(atPath: oldestFile.path),
                   let fileSize = attributes[.size] as? Int {
                    try? self.fileManager.removeItem(at: oldestFile)
                    totalSize -= fileSize
                }
            }
        }
    }
    
    // MARK: - Resize Image
    
    private func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage? {
        let size = image.size
        let widthRatio = targetSize.width / size.width
        let heightRatio = targetSize.height / size.height
        let scalingFactor = min(widthRatio, heightRatio)
        let scaledSize = CGSize(width: size.width * scalingFactor, height: size.height * scalingFactor)
        
        UIGraphicsBeginImageContextWithOptions(scaledSize, false, 0.0)
        image.draw(in: CGRect(origin: .zero, size: scaledSize))
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return resizedImage
    }
}
