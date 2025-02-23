//
//  LoadingView.swift
//  CoinRanking
//
//  Created by John Gachuhi on 22/02/2025.
//

import SwiftUI

struct LoadingView: View {
    
    var body: some View {
        
        VStack(spacing: 0) {
            
            ProgressView()
                .foregroundStyle(.accent)
                .padding()

            Text("Loading...")
                .font(.system(size: 18, weight: .medium, design: .rounded))
                .foregroundColor(.gray)
            
        }
        .padding(50)
        .background(Color.gray.opacity(0.2))
        .cornerRadius(20)
        
        
    }

}

//#Preview {
//    LoadingView()
//}
