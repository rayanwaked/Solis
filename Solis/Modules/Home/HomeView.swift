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
            headline
            weight
            HStack(spacing: 0) {
                water
                steps
            }
        }
        .onAppear(perform: healthManager.requestAuthorization)
        .background(Image("BackgroundImage").resizable().ignoresSafeArea(.all))
    }
}

// MARK: - COMPONENTS
private extension HomeView {
    // MARK: - HEADER
    var header: some View {
        HStack {
            Text("Solis")
                .headerFont()
            Spacer()
        }
        .padding()
    }
    
    // MARK: - HEADLINE
    var headline: some View {
        HStack {
            VStack(alignment: .leading) {
                Text("Your Health Snapshot Today")
                    .headlineFont()
            }
            .padding()
            Spacer()
        }
        .frame(maxWidth: width, maxHeight: height / 6)
    }
    
    // MARK: - WEIGHT
    @ViewBuilder
    var weight: some View {
        let latestDate = healthManager.weightThisWeek.keys.sorted().last
        let latestWeight = healthManager.weightThisWeek[latestDate ?? Date()] ?? 0.0
        
        VStack {
            HStack {
                Text("Weight")
                    .subheadFont()
                Spacer()
                if let latestDate = healthManager.weightThisWeek.keys.sorted().last {
                    Text("\(healthManager.weightThisWeek[latestDate] ?? 0.0, specifier: "%.2f") lbs")
                        .subheadFont()
                } else {
                    Text("No Data")
                        .subheadFont()
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
            .chartYScale(domain: latestWeight / 1.01...latestWeight * 1.01)
            .padding()
            .frame(maxWidth: width, maxHeight: height)
            .background(Color.gray.opacity(0.1))
        }
        .padding()
        .frame(maxWidth: width, maxHeight: height)
    }
    
    // MARK: - WATER
    var water: some View {
        VStack(alignment: .leading, spacing: -10) {
            Spacer()
            Text("\(healthManager.waterToday)")
                .largeFont()
            Text("water")
                .subheadFont()
        }
        .padding(.leading)
        .frame(maxWidth: width, maxHeight: height * 0.15, alignment: .leading)
    }
    
    // MARK: - STEPS
    var steps: some View {
        VStack(alignment: .leading, spacing: -10) {
            Spacer()
            Text("\(healthManager.stepsToday)")
                .largeFont()
            Text("steps")
                .subheadFont()
        }
        .padding(.leading)
        .frame(maxWidth: width, maxHeight: height * 0.15, alignment: .leading)
    }
}

// MARK: - FONT MODIFIERS
private extension View {
    func headerFont() -> some View {
        font(.largeTitle).fontWeight(.heavy)
    }
    
    func headlineFont() -> some View {
        font(.system(size: 38)).fontWeight(.bold)
    }
    
    func largeFont() -> some View {
        font(.system(size: 44)).fontWeight(.black)
    }
    
    func subheadFont() -> some View {
        font(.system(size: 30)).fontWeight(.medium)
    }
}


// MARK: - PREVIEW
#Preview {
    HomeView()
}
