//
//  DiaryModel.swift
//  MyFitnessPal
//
//  Created by Nicola Rigoni on 22/11/22.
//

import Foundation


struct DiaryModel: Identifiable {
    let id: String = UUID().uuidString
    let foodID: String
    let meal: MealModel
    let food: FoodModel
}
