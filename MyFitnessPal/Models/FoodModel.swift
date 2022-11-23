//
//  FoodModel.swift
//  MyFitnessPal
//
//  Created by Nicola Rigoni on 14/11/22.
//

import Foundation

struct FoodModel: Identifiable, Codable {
    let id: String? = UUID().uuidString
    let product: ProductModel?
    let status: Int?
    let statusVerbose: String?
    
    enum CodingKeys: String, CodingKey {
        case id = "code"
        case product, status
        case statusVerbose = "status_verbose"
    }
}

struct ProductModel: Identifiable, Codable {
    let id: String? //= UUID().uuidString
    let brands: String?
    var brand: String {
        if let brands = brands, brands != "" {
            return brands
        } else {
            return "N/D"
        }
    }
    let categories: String?
    //let genericName: String?
    let productName: String?
    var name: String {
        if let productName = productName, productName != "" {
            return productName
        } else {
            return "N/D"
        }
    }
    let imageFrontURL: String?
    let servingQuantity: Double?
    let servingSize: String?
    let nutriments: NutrimentsModel?
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case brands, categories, nutriments
        //case genericName = "generic_name"
        case productName = "product_name"
        case imageFrontURL = "image_front_url"
        case servingQuantity = "serving_quantity"
        case servingSize = "serving_size"
    }
}

struct NutrimentsModel: Codable {
    let carbohydrates, carbohydrates100G: Double?
    let carbohydratesServing: Double?
    let carbohydratesUnit: String?
    let carbohydratesValue: Double?
    var carbohydrate100GFormatted: String {
        if let carbohydrates100G = carbohydrates100G {
            return String(carbohydrates100G) + " " + (carbohydratesUnit ?? "g")
        } else {
            return "0 g"
        }
    }
    var carbohydrateServingFormatted: String {
        if let carbohydratesServing = carbohydratesServing {
            return String(carbohydratesServing) + " " + (carbohydratesUnit ?? "g")
        } else {
            return "0 g"
        }
    }
    let energy, energyKcal, energyKcal100G: Double?
    let energyKcalUnit: String?
    let energyKcalValue, energyKj, energyKj100G, energyKjServing: Double?
    let energyKjUnit: String?
    let energyKjValue, energy100G, energyServing: Double?
    let energyUnit: String?
    var energy100GFormatted: String {
        if let energy100G = energy100G {
            return String(energy100G) + " " + (energyUnit ?? "cal")
        } else {
            return "0 cal"
        }
    }
    var energyServingFormatted: String {
        if let energyServing = energyServing {
            return String(energyServing) + " " + (energyUnit ?? "cal")
        } else {
            return "0 cal"
        }
    }
    let energyValue, fat, fat100G: Double?
    let fatServing: Double?
    let fatUnit: String?
    let fatValue, fiber, fiber100G: Double?
    var fat100GFormatted: String {
        if let fat100G = fat100G {
            return String(fat100G) + " " + (fatUnit ?? "g")
        } else {
            return "0 g"
        }
    }
    var fatServingFormatted: String {
        if let fatServing = fatServing {
            return String(fatServing) + " " + (fatUnit ?? "g")
        } else {
            return "0 g"
        }
    }
    let fiberServing: Double?
    let fiberUnit: String?
    let fiberValue: Double?
    let proteins, proteins100G: Double?
    let proteinsServing: Double?
    let proteinsUnit: String?
    let proteinsValue: Double?
    var protein100GFormatted: String {
        if let proteins100G = proteins100G {
            return String(proteins100G) + " " + (proteinsUnit ?? "g")
        } else {
            return "0 g"
        }
    }
    var proteinServingFormatted: String {
        if let proteinsServing = proteinsServing {
            return String(proteinsServing) + " " + (proteinsUnit ?? "g")
        } else {
            return "0 g"
        }
    }
    let salt, salt100G, saltServing: Double?
    let saltUnit: String?
    let saltValue, saturatedFat, saturatedFat100G, saturatedFatServing: Double?
    let saturatedFatUnit: String?
    let saturatedFatValue, sodium, sodium100G, sodiumServing: Double?
    let sodiumUnit: String?
    let sodiumValue: Double?
    let sugars, sugars100G: Double?
    let sugarsServing: Double?
    let sugarsUnit: String?
    let sugarsValue: Double?

    enum CodingKeys: String, CodingKey {
        case carbohydrates
        case carbohydrates100G = "carbohydrates_100g"
        case carbohydratesServing = "carbohydrates_serving"
        case carbohydratesUnit = "carbohydrates_unit"
        case carbohydratesValue = "carbohydrates_value"
        case energy
        case energyKcal = "energy-kcal"
        case energyKcal100G = "energy-kcal_100g"
        case energyKcalUnit = "energy-kcal_unit"
        case energyKcalValue = "energy-kcal_value"
        case energyKj = "energy-kj"
        case energyKj100G = "energy-kj_100g"
        case energyKjServing = "energy-kj_serving"
        case energyKjUnit = "energy-kj_unit"
        case energyKjValue = "energy-kj_value"
        case energy100G = "energy_100g"
        case energyServing = "energy_serving"
        case energyUnit = "energy_unit"
        case energyValue = "energy_value"
        case fat
        case fat100G = "fat_100g"
        case fatServing = "fat_serving"
        case fatUnit = "fat_unit"
        case fatValue = "fat_value"
        case fiber
        case fiber100G = "fiber_100g"
        case fiberServing = "fiber_serving"
        case fiberUnit = "fiber_unit"
        case fiberValue = "fiber_value"
        case proteins
        case proteins100G = "proteins_100g"
        case proteinsServing = "proteins_serving"
        case proteinsUnit = "proteins_unit"
        case proteinsValue = "proteins_value"
        case salt
        case salt100G = "salt_100g"
        case saltServing = "salt_serving"
        case saltUnit = "salt_unit"
        case saltValue = "salt_value"
        case saturatedFat = "saturated-fat"
        case saturatedFat100G = "saturated-fat_100g"
        case saturatedFatServing = "saturated-fat_serving"
        case saturatedFatUnit = "saturated-fat_unit"
        case saturatedFatValue = "saturated-fat_value"
        case sodium
        case sodium100G = "sodium_100g"
        case sodiumServing = "sodium_serving"
        case sodiumUnit = "sodium_unit"
        case sodiumValue = "sodium_value"
        case sugars
        case sugars100G = "sugars_100g"
        case sugarsServing = "sugars_serving"
        case sugarsUnit = "sugars_unit"
        case sugarsValue = "sugars_value"
    }
}
