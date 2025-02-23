//
//  ChartView.swift
//  CoinRanking
//
//  Created by John Gachuhi on 21/02/2025.
//

import SwiftUI
import Charts

struct SparklineCellView: View {
    
    let data: [Double]
    let change: Double

    var body: some View {
        
        VStack(spacing: 5) {
            
            let isPositive = change > 0
            
            // MARK: - This is to allow for scaling of Data for Visibilities Sake
            
            let scaledData = data.map { ($0 - data[0]) * 10 }
            
            Text("\(isPositive ? "+" : "")\(String(format: "%.2f", change))")
                .font(.system(size: 16, weight: .bold, design: .rounded))
                .foregroundStyle(isPositive ? .green : .red)
                .frame(maxWidth: 80, alignment: .trailing)
            
            Chart {
                ForEach(Array(scaledData.enumerated()), id: \.offset) { index, value in
                    LineMark(
                        x: .value("Time", index),
                        y: .value("Value", value)
                    )
                    .interpolationMethod(.catmullRom)
                    AreaMark(
                        x: .value("Time", index),
                        yStart: .value("Min", scaledData.min() ?? 0),
                        yEnd: .value("Value", value)
                    )
                    .interpolationMethod(.catmullRom)
                    .foregroundStyle(LinearGradient(colors: [isPositive ? .green : .red, .clear], startPoint: .top, endPoint: .bottom))
                }
            }
            .chartXAxis(.hidden)
            .chartYAxis(.hidden)
            .foregroundStyle(isPositive ? .green : .red)
            .frame(width: 80, height: 30)
        }
    }
}

struct SparklineView: View {
    
    let data: [Double]
    let change: Double
    
    // MARK: - Generate an array of dates for the past 24 hours
    
    var past24Hours: [Date] {
        let calendar = Calendar.current
        let now = Date()
        return (0..<24).map { index in
            calendar.date(byAdding: .hour, value: -index, to: now)!
        }.reversed()
    }

    var body: some View {
        
        VStack(spacing: 5) {
            
            let isPositive = change > 0
            
            // MARK: - This is to allow for scaling of Data for Visibilities Sake
            
            let scaledData = data.map { ($0 - data[0]) * 10 }
            
            // MARK: - Filter out nil values and pair with time
            
            var filteredData: [(Date, Double)] {
                Array(zip(past24Hours, scaledData.compactMap { $0 }))
            }
            
            Chart {
                ForEach(filteredData, id: \.0) { date, value in
                    LineMark(
                        x: .value("Time", date),
                        y: .value("Amount", value)
                    )
                    .interpolationMethod(.catmullRom)
                    
                    AreaMark(
                        x: .value("Time", date),
                        yStart: .value("Min", filteredData.map { $0.1 }.min() ?? 0),
                        yEnd: .value("Amount", value)
                    )
                    .interpolationMethod(.catmullRom)
                    .foregroundStyle(LinearGradient(
                        colors: [isPositive ? .green : .red, .clear],
                        startPoint: .top,
                        endPoint: .bottom
                    ))
                }
            }
            .chartXAxis {
                AxisMarks(values: .stride(by: .hour, count: 6)) { value in
                    AxisGridLine()
                    AxisTick()
                    AxisValueLabel(format: .dateTime.hour())
                }
            }
            .chartYAxis {
                AxisMarks(position: .leading)
            }
            .foregroundStyle(isPositive ? .green : .red)
            .frame(height: 250)
        }
    }
}


struct ContentView: View {
    
    let data: Coin = .bitCoinMocked
    
    var body: some View {
        VStack {
            
            let doubleArray = data.sparkline?.compactMap { Double($0 ?? "") } ?? []
            let change = Double(data.change ?? "") ?? 0
            
            SparklineView(data: doubleArray, change: change)
                .padding(10)
                .background(Color.gray.opacity(0.1))
                .cornerRadius(8)
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
