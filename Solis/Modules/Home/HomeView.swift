//
//  HomeView.swift
//  Solis
//
//  Created by Rayan Waked on 8/21/24.
//

// MARK: - IMPORT
import SwiftUI
import Charts

// MARK: - VIEW
struct HomeView: View {
    @StateObject var healthManager = HealthManager.shared
    
    var body: some View {
        VStack(spacing: 0) {
            header
            stats
            weight
            HStack(spacing: 0) {
                water
                steps
            }
        }
        .onAppear(perform: healthManager.requestAuthorization)
    }
}

// MARK: - COMPONENTS
private extension HomeView {
    // MARK: - HEADER
    var header: some View {
        HStack {
            Text("Solis")
                .font(.largeTitle).fontWeight(.heavy)
            Spacer()
        }
        .padding()
        .background(Color.indigo)
    }
    
    // MARK: - STATS
    var stats: some View {
        VStack {
            
        }
        .frame(maxWidth: width, maxHeight: height)
        .background(Color.blue)
    }
    
    // MARK: - WEIGHT
    var weight: some View {
        VStack {
            HStack {
                Text("Weight")
                    .fontWeight(.medium)
                    .font(.system(size: 30))
                    .padding()
                Spacer()
                if let latestDate = healthManager.weightThisWeek.keys.sorted().last {
                    Text("\(healthManager.weightThisWeek[latestDate] ?? 0.0, specifier: "%.2f") lbs")
                        .fontWeight(.medium)
                        .font(.system(size: 30))
                        .padding()
                } else {
                    Text("No Data")
                        .fontWeight(.medium)
                        .font(.system(size: 30))
                        .padding()
                }
            }
            Spacer()
            Chart {
                ForEach(Array(healthManager.weightThisWeek.keys.sorted()), id: \.self) { date in
                    LineMark(
                        x: .value("Date", date, unit: .day),
                        y: .value("Weight", healthManager.weightThisWeek[date] ?? 0.0)
                    )
                    .symbol(.circle)
                    .interpolationMethod(.catmullRom)
                }
            }
            .padding()
            .frame(maxWidth: .infinity, maxHeight: 300)
            .background(Color.gray.opacity(0.1))
        }
        .frame(maxWidth: width, maxHeight: height / 3.25)
        .background(Color.gray)
    }
    
    // MARK: - WATER
    var water: some View {
        VStack(alignment: .leading, spacing: -10) {
            Spacer()
            Text("\(healthManager.waterToday)")
                .fontWeight(.black)
                .font(.system(size: 44))
                .padding(.leading)
            Text("water")
                .fontWeight(.medium)
                .font(.system(size: 30))
                .padding(.leading)
        }
        .frame(maxWidth: width, maxHeight: height * 0.125, alignment: .leading)
        .background(Color.yellow)
    }
    
    // MARK: - STEPS
    var steps: some View {
        VStack(alignment: .leading, spacing: -10) {
            Spacer()
            Text("\(healthManager.stepsToday)")
                .fontWeight(.black)
                .font(.system(size: 44))
                .padding(.leading)
            Text("steps")
                .fontWeight(.medium)
                .font(.system(size: 30))
                .padding(.leading)
        }
        .frame(maxWidth: width, maxHeight: height * 0.125, alignment: .leading)
        .background(Color.orange)
    }
}

// MARK: - PREVIEW
#Preview {
    HomeView()
}
