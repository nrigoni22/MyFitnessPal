//
//  TabBarViewModel.swift
//  MyFitnessPal
//
//  Created by Nicola Rigoni on 14/11/22.
//

import Foundation
import HealthKit

class TabBarViewModel: ObservableObject {
    @Published var food: FoodModel?
    
    @Published var breakfastFood: [DiaryModel] = []
    @Published var lunchFood: [DiaryModel] = []
    @Published var snackFood: [DiaryModel] = []
    @Published var dinnerFood: [DiaryModel] = []
    
    @Published var activityGoal: Double = 0.0
    @Published var activityBurned: Double = 0.0
    @Published var dietaryEnergy: Double = 0.0
    
    let healthRepository = HKRepository.shared
    
    init() {
        healthRepository.requestAutorization { status in
            print("requestAutorization \(status.description)")
        }
    }
    
    func getFood(barcode: String) async {
        let urlString = "https://world.openfoodfacts.org/api/v0/product/" + barcode + ".json"
        guard let url: URL = URL(string: urlString) else { return }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            //print("response \(response)")
            try await MainActor.run(body: {
                self.food = try JSONDecoder().decode(FoodModel.self, from: data)
                print("FOOD: \(food)")
            })
        } catch {
            print("error getFood: \(error.localizedDescription)")
        }
    }
    
    func getFoodData(barcode: String) async -> FoodModel? {
        let urlString = "https://world.openfoodfacts.org/api/v0/product/" + barcode + ".json"
        guard let url: URL = URL(string: urlString) else { return nil }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            //print("response \(response)")
            //try await MainActor.run(body: {
            return try JSONDecoder().decode(FoodModel.self, from: data)
            print("FOOD: \(food)")
           //})
        } catch {
            print("error getFood: \(error.localizedDescription)")
        }
        return nil
    }
    
    func saveMealToHealth(selectedServing: ServingSize, selectedMeal: MealModel, quantityServing: Int) {
        var carb: Double
        var energy: Double
        var protein: Double
        var fat: Double
        
        if let food {
            if let product = food.product {
                if let nutriment = product.nutriments {
                    if selectedServing == .gr100 {
                        carb = nutriment.carbohydrates100G ?? 0.0
                        healthRepository.saveDataToHealth(type: .dietaryCarbohydrates, data: carb, unit: healthRepository.getUnit(from: nutriment.carbohydratesUnit ?? "g"), foodID: product.id ?? "", meal: selectedMeal.rawValue, productName: product.name)
                        
                        energy = nutriment.energy100G ?? 0.0
                        healthRepository.saveDataToHealth(type: .dietaryEnergyConsumed, data: energy, unit: healthRepository.getUnit(from: nutriment.energyUnit ?? "kcal"), foodID: product.id ?? "", meal: selectedMeal.rawValue, productName: product.name)
                        
                        
                        protein = nutriment.proteins100G ?? 0.0
                        healthRepository.saveDataToHealth(type: .dietaryProtein, data: protein, unit: healthRepository.getUnit(from: nutriment.proteinsUnit ?? "g"), foodID: product.id ?? "", meal: selectedMeal.rawValue, productName: product.name)
                        
                        fat = nutriment.fat100G ?? 0.0
                        healthRepository.saveDataToHealth(type: .dietaryFatTotal, data: fat, unit: healthRepository.getUnit(from: nutriment.fatUnit ?? "g"), foodID: product.id ?? "", meal: selectedMeal.rawValue, productName: product.name)
                    }
                }
            }
        }
    }
    
    func getDiaryDataFromHealth(type: HKQuantityType, date: Date) {
        breakfastFood = []
        lunchFood = []
        snackFood = []
        dinnerFood = []
        
        Task {
            let samples = try await healthRepository.getDataFromHealth(type: type, date: date)
            for sample in samples {
                if sample.metadata?["meal"] as! String == "Breakfast" {
                    let foodCode = sample.metadata?["food"] as? String
                    if let code = foodCode {
                        if let foodData = await getFoodData(barcode: code) {
                            let food = DiaryModel(foodID: code, meal: .breakfast, food: foodData)
                            await MainActor.run {
                                breakfastFood.append(food)
                            }
                        }
                    }
                } else if sample.metadata?["meal"] as! String == "Lunch" {
                    let foodCode = sample.metadata?["food"] as? String
                    if let code = foodCode {
                        if let foodData = await getFoodData(barcode: code) {
                            let food = DiaryModel(foodID: code, meal: .breakfast, food: foodData)
                            await MainActor.run {
                                lunchFood.append(food)
                            }
                        }
                    }
                } else if sample.metadata?["meal"] as! String == "Snack" {
                    let foodCode = sample.metadata?["food"] as? String
                    if let code = foodCode {
                        if let foodData = await getFoodData(barcode: code) {
                            let food = DiaryModel(foodID: code, meal: .breakfast, food: foodData)
                            await MainActor.run {
                                snackFood.append(food)
                            }
                        }
                    }
                } else if sample.metadata?["meal"] as! String == "Dinner" {
                    let foodCode = sample.metadata?["food"] as? String
                    if let code = foodCode {
                        if let foodData = await getFoodData(barcode: code) {
                            let food = DiaryModel(foodID: code, meal: .breakfast, food: foodData)
                            await MainActor.run {
                                dinnerFood.append(food)
                            }
                        }
                    }
                }
            }
        }
    }
    
    func getDashboardCardData() {
        Task {
            let activitySummer = try await healthRepository.getActivityDataFromHealth(date: Date())
//            for activity in activitySummer {
//                let goal = activity.activeEnergyBurnedGoal.doubleValue(for: .kilocalorie())
//                let burned = activity.activeEnergyBurned.doubleValue(for: .kilocalorie())
//                print("goal: \(goal)")
//                print("burned: \(burned)")
//            }
//            print(activitySummer.count)
            let dietaryEnergy = try await healthRepository.getDataFromHealth(type: HKQuantityType(.dietaryEnergyConsumed), date: Date())
            await MainActor.run {
                activityGoal = activitySummer.first?.activeEnergyBurnedGoal.doubleValue(for: .kilocalorie()) ?? 0.0
                activityBurned = activitySummer.first?.activeEnergyBurned.doubleValue(for: .kilocalorie()) ?? 0.0
                self.dietaryEnergy = dietaryEnergy.first?.quantity.doubleValue(for: .kilocalorie()) ?? 0.0
            }
        }
    }
}

//func downloadWithAsync() async throws -> UIImage? {
//    do {
//        let (data, response) = try await URLSession.shared.data(from: url)
//        let image = handleResponse(data: data, response: response)
//        return image
//    } catch  {
//        throw error
//    }
//
//}
/*
func getFood(barcode: String) async {
    let urlString: String = "https://nutritionix-api.p.rapidapi.com/v1_1/item?upc=" + barcode
    guard let url: URL = URL(string: urlString) else { return }
    
    let headers = [
        "X-RapidAPI-Key": "6984dbca63msha72af3a2c7e3668p18dfbejsn66a9d066478b",
        "X-RapidAPI-Host": "nutritionix-api.p.rapidapi.com"
    ]
    
    var request = URLRequest(url: url)
    request.httpMethod = "GET"
    request.allHTTPHeaderFields = headers

    
    do {
        let (data, _) = try await URLSession.shared.data(for: request)
        try await MainActor.run(body: {
            self.food = try JSONDecoder().decode(FoodModel.self, from: data)
            print("FOOD: \(food)")
        })
    } catch  {
        print("error getFood: \(error.localizedDescription)")
    }
}*/
