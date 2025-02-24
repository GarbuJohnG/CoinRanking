# Coin Ranking

# Overview

CoinRanking App has been developed as a fulfilment of a Mobile assessment showcasing knowledge in IOS Development.

The App provides a list of cryptocurrency coins showing various details like performance and prices. It displayd a list of all the top 100 coins, with a pagination, loading 20 items at a time with a load more button. It has a favorites page that can ve favorited/unfavorited by swiping left on a Table Cell. It also has a detailed page which shows all the relecant details concerning the Coins.

It's built using Swift, leveraging programmatic UIKit for the major Views and UIKit for the smaller Views.

## Run the App

Pull or download the project to your machine and run 'CoinRanking.xcodeproj' using XCode. Build and run the app on the preferred simulator or device (NOTE: You'll have to register the AppID with your Developer ID to run it on your Device).

Add a [CoinRanking](https://coinranking.com) Api Key to the App by replacing "_coinranking_api_key_" with your API key in the "_appconfigs.xcconfig_" file within the root folder of your app. This is to allow one access the APIs from [CoinRanking](https://coinranking.com). Once done, drag the file into your project in the root folder and associate it with your target in this case "_CoinRanking_". Once done, rebuild and run.

## App Use

On app launch, a call is made to [CoinRanking](https://coinranking.com) to fetch a list of Coins. These coins are limited to 20 per call implemented in a paginated way where it incrementally up until it gets to the maximum specified 100 Coins. 

One can then swipe left to favorite/unfavorite a Coin which then makes it visible on the favorites page. The favorites are stored in AppStorage to allow for persistence even when app is closed and reopened.

On clicking any cell either on the home page or the favorites page more coin specific details are fetched and displayed.

## Endpoints

- [CoinRanking](https://coinranking.com)

## Persistence

- AppStorage has been used to save one's favorite coins
- FileManager has been used to create an image cache to avoid too much network activity and processing considering the complexity posed by the svg images

## Libraries Used

- SVGKit - [SVGKit](https://github.com/SVGKit/SVGKit.git). **Justification**: SwiftUI's AsyncImage does not support svg images so as a workaround I chose to download the svg data using SVGKit to turn it to an image.

## Challenges Encountered

- One of the challenges faced was displaying the svg images the API provides. I was able to fix this by downloading the svg data and using the [SVGKit](https://github.com/SVGKit/SVGKit.git) library, convert it to an image. This posed another concurrency challenge leading me to use multithreading to allow proper management of the many download requests. The images were then cached to avoid repeating the multiple download calls thus reducing network activity and processing overhead.

## Tech and Structures

- [x] URLSession
- [X] RESTful APIs
- [x] SwiftUI
- [x] UIKit
- [x] Combine
- [x] MVVM Architecture
- [x] AppStorage
- [x] FileManager

## Screenshots

![Simulator Screenshot - iPhone 16 Pro - 2025-02-23 at 16 42 18](https://github.com/user-attachments/assets/571da11a-2cd1-4c03-9be7-e937599eceee)
![Simulator Screenshot - iPhone 16 Pro - 2025-02-23 at 16 42 33](https://github.com/user-attachments/assets/26f3fe16-9317-4d71-9c40-d19cb03c62cd)
![Simulator Screenshot - iPhone 16 Pro - 2025-02-23 at 16 42 38](https://github.com/user-attachments/assets/d55948f3-884e-40f8-a3b0-4b834556cc71)
![Simulator Screenshot - iPhone 16 Pro - 2025-02-23 at 16 42 24](https://github.com/user-attachments/assets/1ed40c0b-d5e4-462f-95ec-2528b03d89ec)
![Simulator Screenshot - iPhone 16 Pro - 2025-02-23 at 16 42 51](https://github.com/user-attachments/assets/f7bc7763-8052-41cd-a8f3-8ee2775c4aae)
![Simulator Screenshot - iPhone 16 Pro - 2025-02-23 at 16 43 01](https://github.com/user-attachments/assets/7e1cbff7-15ac-497c-886f-270d8eb7ef16)


