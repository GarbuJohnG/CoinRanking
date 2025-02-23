//
//  SocialsBtnsView.swift
//  CoinRanking
//
//  Created by John Gachuhi on 23/02/2025.
//

import SwiftUI
import SafariServices

enum AppIcons {
    
    case asset(String)

    var image: Image? {
        switch self {
        case .asset(let name):
            return Image(name)
        }
    }

    static func from(_ name: String) -> Image? {
        return AppIcons.asset(name).image?.renderingMode(.template)
    }
    
}

struct SocialsBtnsView: View {
    
    let coinDetails: CoinDetail
    
    @State private var showSafari = false
    @State private var selectedURL: URL?
    
    let columns = [
        GridItem(.flexible(), spacing: 20),
        GridItem(.flexible(), spacing: 20)
    ]
    
    var body: some View {
        VStack {
            
            Text("Social Links")
                .font(.system(size: 18, weight: .bold, design: .rounded))
                .frame(maxWidth: .infinity, alignment: .leading)
            
            LazyVGrid(columns: columns, spacing: 10) {
                ForEach(coinDetails.links ?? [], id: \.url) { link in
                    SocialBtnView(link: link)
                }
            }
        }
    }
    
    func SocialBtnView(link: Link) -> some View {
        
        Button {
            if let urlString = link.url, let url = URL(string: urlString) {
                selectedURL = url
                showSafari = true
            }
        } label: {
            HStack {
                
                AppIcons.from(link.type ?? "")?
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .foregroundColor(Color(hex: coinDetails.color ?? "#FF5733"))
                    .frame(width: 18, height: 18)
                    .padding(7)
                    .background(.gray.opacity(0.2))
                    .cornerRadius(10)
                
                Text("\(link.name ?? "")")
                    .font(.system(size: 11, weight: .regular, design: .rounded))
                    .multilineTextAlignment(.leading)
                
                Spacer()
                
            }
            
        }
        .sheet(isPresented: $showSafari) {
            if let url = selectedURL {
                SafariView(url: url)
            }
        }
        
    }
    
    
    
}

#Preview {
    SocialsBtnsView(coinDetails: .etheriumMocked)
}
