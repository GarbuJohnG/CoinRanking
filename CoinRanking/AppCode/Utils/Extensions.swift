//
//  Extensions.swift
//  CoinRanking
//
//  Created by John Gachuhi on 21/02/2025.
//

import UIKit
import SwiftUI

extension String {
    
    func formatAmount() -> String {
        
        if let doubleValue = Double(self) {
            
            let formatter = NumberFormatter()
            formatter.numberStyle = .decimal
            formatter.minimumFractionDigits = 2
            formatter.maximumFractionDigits = 2
            formatter.groupingSeparator = ","

            if let formattedString = formatter.string(from: NSNumber(value: doubleValue)) {
                return formattedString
            } else {
                return self
            }
        } else {
            return self
        }
        
    }
    
    func formatLargeNumbers() -> String {
        guard let number = Double(self) else { return "" }

        switch number {
        case 1_000_000_000_000...:
            return String(format: "%.2f T", number / 1_000_000_000_000)
        case 1_000_000_000...:
            return String(format: "%.2f B", number / 1_000_000_000)
        case 1_000_000...:
            return String(format: "%.2f M", number / 1_000_000)
        case 1_000...:
            return String(format: "%.2f K", number / 1_000)
        default:
            return String(format: "%.0f", number)
        }
    }
    
    func formatMultiDecimalNumbers() -> String {
        guard let number = Double(self) else { return "" }
        
        switch number {
        case 1_000_000_000_000...:
            return String(format: "%.5f T", number / 1_000_000_000_000)
        case 1_000_000_000...:
            return String(format: "%.5f B", number / 1_000_000_000)
        case 1_000_000...:
            return String(format: "%.5f M", number / 1_000_000)
        case 1_000...:
            return String(format: "%.5f K", number / 1_000)
        default:
            return String(format: "%.5f", number)
        }
    }
    
}

extension UIViewController {

    // MARK: - Properties
    private struct AssociatedKeys {
        static var hostingControllerKey: UnsafeRawPointer = UnsafeRawPointer(bitPattern: "hostingControllerKey".hashValue)!
    }

    private var hostingController: UIHostingController<LoadingView>? {
        get {
            return objc_getAssociatedObject(self, AssociatedKeys.hostingControllerKey) as? UIHostingController<LoadingView>
        }
        set {
            objc_setAssociatedObject(self, AssociatedKeys.hostingControllerKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

    // MARK: - Add Loading View
    func createLoadingView() {
        
        guard hostingController == nil else { return }

        let loadingView = LoadingView()
        let hostingController = UIHostingController(rootView: loadingView)

        addChild(hostingController)
        view.addSubview(hostingController.view)
        hostingController.didMove(toParent: self)

        hostingController.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            hostingController.view.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            hostingController.view.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            hostingController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            hostingController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])

        self.hostingController = hostingController
    }

    // MARK: - Remove Loading View
    func removeLoadingView() {
        guard let hostingController = hostingController else { return }

        hostingController.willMove(toParent: nil)
        hostingController.view.removeFromSuperview()
        hostingController.removeFromParent()

        self.hostingController = nil
    }
    
}

extension Color {
    
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        
        let a, r, g, b: Double
        switch hex.count {
        case 6:
            (a, r, g, b) = (1,
                            Double((int >> 16) & 0xFF) / 255,
                            Double((int >> 8) & 0xFF) / 255,
                            Double(int & 0xFF) / 255)
        case 8:
            (a, r, g, b) = (Double((int >> 24) & 0xFF) / 255,
                            Double((int >> 16) & 0xFF) / 255,
                            Double((int >> 8) & 0xFF) / 255,
                            Double(int & 0xFF) / 255)
        default:
            (a, r, g, b) = (1, 0, 0, 0) 
        }
        
        self.init(.sRGB, red: r, green: g, blue: b, opacity: a)
    }
    
}

