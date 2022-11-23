//
//  HKRepository.swift
//  MyFitnessPal
//
//  Created by Nicola Rigoni on 14/11/22.
//

import Foundation
import HealthKit

final class HKRepository {
    static let shared = HKRepository()
    var store: HKHealthStore?
    
    let typesToRead = Set([
        HKQuantityType(.activeEnergyBurned),
        HKQuantityType(.dietaryWater),
        HKQuantityType(.dietaryEnergyConsumed),
        HKQuantityType(.dietaryCarbohydrates),
        HKQuantityType(.dietaryFatTotal),
        HKQuantityType(.dietaryProtein),
        HKObjectType.activitySummaryType()
    ])
    
    let typesToWrite = Set([
        HKQuantityType(.dietaryWater),
        HKQuantityType(.dietaryEnergyConsumed),
        HKQuantityType(.dietaryCarbohydrates),
        HKQuantityType(.dietaryFatTotal),
        HKQuantityType(.dietaryProtein)
    ])
    
    init() {
        if HKHealthStore.isHealthDataAvailable() {
            print("isHealthDataAvailable")
            store = HKHealthStore()
        }
    }
    
    func requestAutorization(completion: @escaping(Bool) -> ()) {
        guard let store = store else { return }
        
        store.requestAuthorization(toShare: typesToWrite, read: typesToRead) { success, error in
            completion(success)
        }
    }
    
    func saveDataToHealth(type: HKQuantityTypeIdentifier, data: Double, unit: HKUnit, foodID: String, meal: String, productName: String) {
//        guard let dataToSaveType = HKQuantityType.quantityType(forIdentifier: type)
//        else {
//            print("this identifier is not longer available in healthkit")
//            return
//        }
        let dataToSaveType = HKQuantityType(type)
        
        //let unit2: HKUnit = .gramUnit(with: .none)
        let quantityAmount = HKQuantity(unit: unit, doubleValue: data)
        let now = Date()
        let metadata = [
            "food": foodID,
            "meal": meal,
            "product name": productName
            ] as NSDictionary
        let sample = HKQuantitySample(type: dataToSaveType, quantity: quantityAmount, start: now, end: now, metadata: metadata as? [String : Any])
        //HKQuantitySample(type: dataToSaveType, quantity: quantityAmount, start: now, end: now)
        
        let correlationType = HKObjectType.correlationType(forIdentifier: HKCorrelationTypeIdentifier.food)
        //let metadata = [HKMetadataKeyFoodType: "985675"]
        let propertyToSend = HKCorrelation(type: correlationType!, start: now, end: now, objects: [sample]/*, metadata: metadata*/)
        
        self.store?.save(propertyToSend, withCompletion: { success, error in
            if error != nil {
                print("error saving sample to healthkit")
            }
        })
    }
    
    func getUnit(from string: String) -> HKUnit {
        switch string {
        case "g":
            return HKUnit.gramUnit(with: .none)
        case "kcal":
            return HKUnit.kilocalorie()
        case "kj":
            return HKUnit.jouleUnit(with: .kilo)
        default:
            return HKUnit.jouleUnit(with: .kilo)
        }
    }
    
//    func getDataFromHealth(type: HKQuantityType) async {
//        let date = Date() // current date or replace with a specific date
//        let calendar = Calendar.current
//        let startTime = calendar.startOfDay(for: date)
//        let endTime = calendar.date(bySettingHour: 23, minute: 59, second: 59, of: date)
//        let inDate = HKQuery.predicateForSamples(withStart: startTime, end: endTime, options: [.strictStartDate])
//        let anchorDescriptor = HKAnchoredObjectQueryDescriptor(predicates: [.quantitySample(type: type)], anchor: nil)
//        if let store = store {
//            let results = try await anchorDescriptor.result(for: store)
//        }
//
//    }
    
    func getDataFromHealth(type: HKQuantityType, date: Date) async throws -> [HKQuantitySample] {
        let startDate = Calendar.current.startOfDay(for: date)
        let endDate = Calendar.current.date(bySettingHour: 23, minute: 59, second: 59, of: date)
        
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate, options: [])
        
        let descriptor = HKSampleQueryDescriptor(predicates: [.quantitySample(type: type, predicate: predicate)], sortDescriptors: [SortDescriptor(\.startDate, order: .forward)])
        
        guard let store else { return [] }
        let results = try await descriptor.result(for: store)
        
//        for result in results {
//            print("result \(result)")
//            print("QUANTITY \(result.quantity.doubleValue(for: .gramUnit(with: .none)))")
//            print("MEAL \(result.metadata?["meal"] as! String)")
//            print("FOOD \(result.metadata?["food"] as! String)")
//        }
        
        return results
//        return try results.map {
//
//            let drinkName = $0.metadata?["drink"] as! String
//            let value = $0.quantity
//            //guard let drink = DrinkType(rawValue: drinkName) else { throw DrinkError.drinkNotFound }
//
//            return DrinkLog(drink: drink.makeDrink(),
//                            quantity: $0.quantity.doubleValue(for: .literUnit(with: .milli)),
//                            date: $0.startDate)
//        }
    }
    
    func getActivityDataFromHealth(date: Date) async throws -> [HKActivitySummary] {
        
        let calendar = Calendar(identifier: .gregorian)

        var startComponents = calendar.dateComponents([.day, .month, .year], from: Date())
//        startComponents.hour = 0
//        startComponents.minute = 0
//        startComponents.second = 0
        startComponents.calendar = calendar

        var endComponents = startComponents
        endComponents.day = 1 + (endComponents.day ?? 0)
        endComponents.calendar = calendar
        let today = HKQuery.predicate(forActivitySummariesBetweenStart: startComponents, end: endComponents)
        let activeSummaryDescriptor = HKActivitySummaryQueryDescriptor(predicate: today)
        guard let store else { return [] }
        return try await activeSummaryDescriptor.result(for: store)

    }
}
