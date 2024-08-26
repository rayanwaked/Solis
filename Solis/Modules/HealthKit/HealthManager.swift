//
//  HomeView.swift
//  Solis
//
//  Created by Rayan Waked on 8/21/24.
//

// MARK: - IMPORT
import Foundation
import HealthKit

// MARK: - HEALTH MANAGER
class HealthManager: ObservableObject {
    static let shared = HealthManager()
    var healthStore = HKHealthStore()
    @Published var weightThisWeek: [Date: Double] = [:]
    @Published var stepsToday: Int = 0
    @Published var waterToday: Int = 0
    
    init() {
        requestAuthorization()
    }

    func fetchAllData() {
        fetchStepsToday()
        fetchTotalWaterToday()
        fetchWeight()
    }
}

// MARK: - REQUEST AUTHORIZATION
extension HealthManager {
    func requestAuthorization() {
        let toReads: Set<HKObjectType> = [
            HKQuantityType(.stepCount),
            HKQuantityType(.bodyMass),
            HKQuantityType(.dietaryWater)
        ]
        
        guard HKHealthStore.isHealthDataAvailable() else {
            print("Health data not available!")
            return
        }
        
        healthStore.requestAuthorization(toShare: nil, read: toReads) { success, error in
            if success {
                self.fetchAllData()
            } else {
                print("Authorization failed with error: \(String(describing: error))")
            }
        }
    }
}

// MARK: - FETCH DATA FROM HEALTHKIT
private extension HealthManager {
    private func fetchWeight() {
        fetchHKSampleData(sampleTypeIdentifier: .bodyMass, timeRange: .startOfWeek, processor: WeightProcessor()) { result in
            switch result {
            case .success():
                print("Successfully fetched weights for this week.")
                print("Weight data: \(self.weightThisWeek)")
            case .failure(let error):
                print("Failed to fetch weights for this week: \(error.localizedDescription)")
            }
        }
    }
    
    private func fetchStepsToday() {
        fetchHKStatisticsData(sampleTypeIdentifier: .stepCount, timeRange: .startOfDay, processor: StepsProcessor()) { result in
            switch result {
            case .success():
                print("Successfully fetched steps for today.")
            case .failure(let error):
                print("Failed to fetch steps for today: \(error.localizedDescription)")
            }
        }
    }
    
    private func fetchTotalWaterToday() {
        fetchHKStatisticsData(sampleTypeIdentifier: .dietaryWater, timeRange: .startOfDay, processor: WaterProcessor()) { result in
            switch result {
            case .success():
                print("Successfully fetched water intake for today.")
            case .failure(let error):
                print("Failed to fetch water intake for today: \(error.localizedDescription)")
            }
        }
    }
}
