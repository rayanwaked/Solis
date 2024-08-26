//
//  HealthSupport.swift
//  Solis
//
//  Created by Rayan Waked on 8/23/24.
//

// MARK: - IMPORT
import HealthKit

extension HealthManager {
    // MARK: - FETCH SAMPLE DATA (I.E. WEIGHT, HEIGHT, ETC.)
    /// Fetches HealthKit sample data of a specific type within a given time range and processes it using a provided data processor.
    ///
    /// This method retrieves `HKSample` data from HealthKit based on the specified type and time range. It then processes the data using a provided `HKDataProcessor` that handles the specific type of data. The results are returned via the completion handler.
    ///
    /// - Parameters:
    ///   - sampleTypeIdentifier: The identifier of the quantity type to fetch. This should be an `HKQuantityTypeIdentifier` that represents the type of data you want to retrieve (e.g., `.bodyMass`).
    ///   - timeRange: An enumeration specifying the time range for the data to be fetched. Use `.startOfDay` for data from the start of the current day, or `.startOfWeek` for data from the past seven days.
    ///   - processor: An instance of `HKDataProcessor` that specifies how to process the fetched data. This processor must handle the type of data specified by `type`.
    ///   - completion: A closure that gets called when the data fetching and processing are complete. It takes a `Result` type where `Void` indicates success and `Error` indicates failure. In case of failure, an `Error` object is provided.
    ///
    /// - Throws: This function may throw errors related to HealthKit queries, which will be passed to the `completion` closure.
    ///
    /// - Example:
    /// ```
    /// healthManager.fetchHKSampleData(type: .bodyMass, timeRange: .startOfWeek, processor: WeightProcessor()) { result in
    ///     switch result {
    ///     case .success():
    ///         print("Successfully fetched weight data.")
    ///     case .failure(let error):
    ///         print("Error fetching weight data: \(error.localizedDescription)")
    ///     }
    /// }
    /// ```
    func fetchHKSampleData<T: HKSample, P: HKDataProcessor>(
        sampleTypeIdentifier: HKQuantityTypeIdentifier,
        timeRange: TimeRange,
        processor: P,
        completion: @escaping (Result<Void, Error>) -> Void
    ) where P.DataType == T {
        // Define quantityType (this is the record type that is being queried)
        let quantityType = HKQuantityType(sampleTypeIdentifier)
        
        // Define time variables
        let now = Date()
        let calendar = Calendar.current
        let startOfRange: Date
        switch timeRange {
        case .startOfDay:
            startOfRange = calendar.startOfDay(for: now)
        case .startOfWeek:
            startOfRange = calendar.date(byAdding: .day, value: -6, to: calendar.startOfDay(for: now)) ?? now
        }
        
        // Define the predicate
        let predicate = HKQuery.predicateForSamples(withStart: startOfRange, end: now)
        
        // Create the query
        let query = HKSampleQuery(sampleType: quantityType, predicate: predicate, limit: HKObjectQueryNoLimit, sortDescriptors: [NSSortDescriptor(key: HKSampleSortIdentifierEndDate, ascending: false)]) { [weak self] _, samples, error in
            guard self != nil else { return }
            
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let samples = samples as? [T] else {
                completion(.failure(NSError(domain: "HealthManagerError", code: 1, userInfo: [NSLocalizedDescriptionKey: "No valid samples found"])))
                return
            }
            
            processor.process(data: samples)
            
            completion(.success(()))
        }
        
        // Execute the query
        healthStore.execute(query)
    }
    
    // MARK: - FETCH STATISTICS DATA (I.E. STEPS, DIETARY, ETC.)
    /// Fetches HealthKit statistics data of a specific type within a given time range and processes it using a provided data processor.
    ///
    /// This method retrieves `HKStatistics` data from HealthKit based on the specified type and time range. It then processes the data using a provided `HKDataProcessor` that handles statistics data. The results are returned via the completion handler.
    ///
    /// - Parameters:
    ///   - sampleTypeIdentifier: The identifier of the quantity type to fetch. This should be an `HKQuantityTypeIdentifier` that represents the type of statistics you want to retrieve (e.g., `.stepCount`).
    ///   - timeRange: An enumeration specifying the time range for the data to be fetched. Use `.startOfDay` for data from the start of the current day, or `.startOfWeek` for data from the past seven days.
    ///   - processor: An instance of `HKDataProcessor` that specifies how to process the fetched statistics data. This processor must handle `HKStatistics` data.
    ///   - completion: A closure that gets called when the data fetching and processing are complete. It takes a `Result` type where `Void` indicates success and `Error` indicates failure. In case of failure, an `Error` object is provided.
    ///
    /// - Throws: This function may throw errors related to HealthKit queries, which will be passed to the `completion` closure.
    ///
    /// - Example:
    /// ```
    /// healthManager.fetchHKStatisticsData(type: .stepCount, timeRange: .startOfDay, processor: StepsProcessor()) { result in
    ///     switch result {
    ///     case .success():
    ///         print("Successfully fetched steps data for today.")
    ///     case .failure(let error):
    ///         print("Error fetching steps data: \(error.localizedDescription)")
    ///     }
    /// }
    /// ```
    func fetchHKStatisticsData<P: HKDataProcessor>(
        sampleTypeIdentifier: HKQuantityTypeIdentifier,
        timeRange: TimeRange,
        processor: P,
        completion: @escaping (Result<Void, Error>) -> Void
    ) where P.DataType == HKStatistics {
        // Define quantityType (this is the record type that is being queried)
        let quantityType = HKQuantityType(sampleTypeIdentifier)
        
        // Define time variables
        let now = Date()
        let calendar = Calendar.current
        let startOfRange: Date
        switch timeRange {
        case .startOfDay:
            startOfRange = calendar.startOfDay(for: now)
        case .startOfWeek:
            startOfRange = calendar.date(byAdding: .day, value: -6, to: calendar.startOfDay(for: now)) ?? now
        }
        
        // Define the predicate
        let predicate = HKQuery.predicateForSamples(withStart: startOfRange, end: now)
        
        // Create the query
        let query = HKStatisticsQuery(quantityType: quantityType, quantitySamplePredicate: predicate, options: .cumulativeSum) { [weak self] _, result, error in
            guard self != nil else { return }
            
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let statistics = result else {
                completion(.failure(NSError(domain: "HealthManagerError", code: 1, userInfo: [NSLocalizedDescriptionKey: "No valid statistics found"])))
                return
            }
            
            processor.process(data: [statistics])
            
            completion(.success(()))
        }
        
        // Execute the query
        healthStore.execute(query)
    }
}

