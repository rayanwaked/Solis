//
//  HealthHelper.swift
//  Solis
//
//  Created by Rayan Waked on 8/23/24.
//

// MARK: - IMPORT
import HealthKit

// MARK: - TIME RANGE
enum TimeRange {
    case startOfDay
    case startOfWeek
}

// MARK: - PROCESSOR PROTOCOL
protocol HKDataProcessor {
    associatedtype DataType
    func process(data: [DataType])
}

// MARK: - PROCESSORS
struct WeightProcessor: HKDataProcessor {
    typealias DataType = HKQuantitySample
    
    func process(data: [HKQuantitySample]) {
        let calendar = Calendar.current
        var weights: [Date: Double] = [:]
        
        for sample in data {
            let weight = sample.quantity.doubleValue(for: .pound())
            let startOfDay = calendar.startOfDay(for: sample.startDate)
            
            if let existingWeight = weights[startOfDay] {
                if sample.endDate > calendar.startOfDay(for: Date()) {
                    weights[startOfDay] = max(existingWeight, weight)
                }
            } else {
                weights[startOfDay] = weight
            }
        }
        
        DispatchQueue.main.async {
            HealthManager.shared.weightThisWeek = weights
        }
    }
}

struct StepsProcessor: HKDataProcessor {
    typealias DataType = HKStatistics
    
    func process(data: [HKStatistics]) {
        let steps = data.reduce(0) { $0 + ($1.sumQuantity()?.doubleValue(for: .count()) ?? 0) }
        DispatchQueue.main.async {
            HealthManager.shared.stepsToday = Int(steps)
        }
    }
}

struct WaterProcessor: HKDataProcessor {
    typealias DataType = HKStatistics
    
    func process(data: [HKStatistics]) {
        let water = data.reduce(0) { $0 + ($1.sumQuantity()?.doubleValue(for: .cupUS()) ?? 0) }
        DispatchQueue.main.async {
            HealthManager.shared.waterToday = Int(water)
        }
    }
}
