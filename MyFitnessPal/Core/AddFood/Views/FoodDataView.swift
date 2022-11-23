//
//  FoodDataView.swift
//  MyFitnessPal
//
//  Created by Nicola Rigoni on 18/11/22.
//

import SwiftUI

enum ServingSize: String, Equatable, CaseIterable {
    case serving = "Serving"
    case gr100 = "100Gr"
}

struct FoodDataView: View {
    @ObservedObject var vm: TabBarViewModel
    let foodNutrition: FoodModel
    @Binding var selectedServing: ServingSize
    @Binding var selectedMeal: MealModel
    @Binding var quantityServing: Int
    @Binding var addIsEnabled: Bool
    
    let breakfastStart: Int = 5
    let breakfastEnd: Int = 11
    let lunchStart: Int = 11
    let lunchEnd: Int = 14
    let snackStart: Int = 14
    let snackEnd: Int = 18
    let dinnerStart: Int = 18
    let dinnerEnd: Int = 22
    
    var body: some View {
        List {
            if let product = foodNutrition.product {
                Section {
                    AsyncImage(url: URL(string: product.imageFrontURL ?? "")) { image in
                        image
                            .resizable()
                            .scaledToFill()
                            .frame(width: 150, height: 150)
                            .clipShape(Circle())
                            .overlay(Circle().stroke(Color.white, lineWidth: 4))
                            .shadow(radius: 5)
                    } placeholder: {
                        Circle()
                            .foregroundColor(.secondary)
                            .frame(width: 150, height: 150)
                            .overlay(Circle().stroke(Color.white, lineWidth: 4))
                            .overlay {
                                ProgressView()
                                    .scaleEffect(2, anchor: .center)
                                    .progressViewStyle(CircularProgressViewStyle(tint: Color.white))
                            }
                            .shadow(radius: 5)
                        
                    }
                }
                .frame(maxWidth: .infinity, alignment: .center)
                .listRowBackground(Color(UIColor.systemGroupedBackground))
                
                HStack {
                    Text("Brand")
                    Spacer()
                    Text(product.brand)
                }
                
                HStack {
                    Text("Product")
                    Spacer()
                    Text(product.name)
                }
                
                
                if let nutriments = product.nutriments {
                    Section {
                        Picker(selection: $selectedServing) {
                            ForEach(ServingSize.allCases, id: \.self) { serving in
                                Text(serving.rawValue)
                            }
                        } label: {
                            Text("Quantity size")
                        }
                        
                        if selectedServing == .serving {
                            LabeledContent {
                                TextField("", value: $quantityServing, format: .number)
                                    .keyboardType(.numberPad)
                                    .multilineTextAlignment(.trailing)
                            } label: {
                                Text("Serving number") 
                                
                            }

                        }
                        
                        Picker(selection: $selectedMeal) {
                            ForEach(MealModel.allCases, id: \.self) { meal in
                                Text(meal.rawValue)
                                   // .id(meal)
                            }
                            
                        } label: {
                            Text("Meal")
                        }
                    }
                    Section {
                        Grid(horizontalSpacing: 30) {
                            GridRow {
                                VStack {
                                    Image("energy")
                                        .resizable()
                                        .scaledToFit()
                                        .background(Circle().fill(.secondary))
                                        .frame(width: 60)
                                        .padding(.bottom, 5)
                                    Text("Energy")
                                        .font(.headline)
                                    Text(selectedServing == .gr100 ? nutriments.energy100GFormatted : nutriments.energyServingFormatted)
                                        .foregroundColor(.secondary)
                                        .font(.callout)
                                        
                                }
                                
                               
                                    
                                
                                VStack {
                                    Image("carbohydrate")
                                        .resizable()
                                        .scaledToFit()
                                        .background(Circle().fill(.secondary))
                                        .frame(width: 60)
                                        .padding(.bottom, 5)
                                    Text("Carb.")
                                        .font(.headline)
                                        .lineLimit(1)
                                    Text(selectedServing == .gr100 ? nutriments.carbohydrate100GFormatted : nutriments.carbohydrateServingFormatted)
                                        .foregroundColor(.secondary)
                                        .font(.callout)
                                }
                                
                                VStack {
                                    Image("protein")
                                        .resizable()
                                        .scaledToFit()
                                        .background(Circle().fill(.secondary))
                                        .frame(width: 60)
                                        .padding(.bottom, 5)
                                    Text("Proteins")
                                        .font(.headline)
                                        .scaledToFit()
                                        .minimumScaleFactor(0.01)
                                        .lineLimit(1)
                                    Text(selectedServing == .gr100 ? nutriments.protein100GFormatted : nutriments.proteinServingFormatted)
                                        .foregroundColor(.secondary)
                                        .font(.callout)
                                }
                                
                                VStack {
                                    Image("fat")
                                        .resizable()
                                        .scaledToFit()
                                        .background(Circle().fill(.secondary))
                                        .frame(width: 60)
                                        .padding(.bottom, 5)
                                    Text("Fats")
                                        .font(.headline)
                                        
                                    Text(selectedServing == .gr100 ? nutriments.fat100GFormatted : nutriments.fatServingFormatted)
                                        .foregroundColor(.secondary)
                                        .font(.callout)
                                }
                            }
                            
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .center)
                    .onAppear {
                        print("ON APPEAR")
                        addIsEnabled = false
                        let currentYear = Calendar.current.component(.year, from: Date())
                        let currentMonth = Calendar.current.component(.month, from: Date())
                        let currentDay = Calendar.current.component(.day, from: Date())
                        if Date().isBetween(Date.from(year: currentYear, month: currentMonth, day: currentDay, hour: breakfastStart)!, and: Date.from(year: currentYear, month: currentMonth, day: currentDay, hour: breakfastEnd)!) {
                            selectedMeal = .dinner
                        } else if Date().isBetween(Date.from(year: currentYear, month: currentMonth, day: currentDay, hour: lunchStart)!, and: Date.from(year: currentYear, month: currentMonth, day: currentDay, hour: lunchEnd)!) {
                            selectedMeal = .lunch
                        } else if Date().isBetween(Date.from(year: currentYear, month: currentMonth, day: currentDay, hour: snackStart)!, and: Date.from(year: currentYear, month: currentMonth, day: currentDay, hour: snackEnd)!) {
                            selectedMeal = .snack
                        } else if Date().isBetween(Date.from(year: currentYear, month: currentMonth, day: currentDay, hour: dinnerStart)!, and: Date.from(year: currentYear, month: currentMonth, day: currentDay, hour: dinnerEnd)!) {
                            selectedMeal = .dinner
                        }
                    }
                }
            }
            
            
        }
        .navigationTitle("Add food")
    }
}

struct FoodDataView_Previews: PreviewProvider {
    static var previews: some View {
        FoodDataView(vm: TabBarViewModel(), foodNutrition: FoodModel(product: ProductModel(id: "", brands: "", categories: "", productName: "", imageFrontURL: "", servingQuantity: 1.0, servingSize: "", nutriments: NutrimentsModel(carbohydrates: 1, carbohydrates100G: 1, carbohydratesServing: 1.0, carbohydratesUnit: "gr", carbohydratesValue: 1, energy: 1, energyKcal: 1, energyKcal100G: 1, energyKcalUnit: "Kcal", energyKcalValue: 1, energyKj: 1, energyKj100G: 1, energyKjServing: 1, energyKjUnit: "", energyKjValue: 1, energy100G: 1, energyServing: 1, energyUnit: "Kj", energyValue: 1, fat: 1, fat100G: 1, fatServing: 1.0, fatUnit: "", fatValue: 1, fiber: 1, fiber100G: 1, fiberServing: 1.0, fiberUnit: "", fiberValue: 1, proteins: 1, proteins100G: 1, proteinsServing: 1.0, proteinsUnit: "g", proteinsValue: 1, salt: 1.0, salt100G: 1.0, saltServing: 1.0, saltUnit: "gr", saltValue: 1.0, saturatedFat: 1.0, saturatedFat100G: 1.0, saturatedFatServing: 1.0, saturatedFatUnit: "gr", saturatedFatValue: 1.0, sodium: 1.0, sodium100G: 1.0, sodiumServing: 1.0, sodiumUnit: "gr", sodiumValue: 1.0, sugars: 1.0, sugars100G: 1.0, sugarsServing: 1.0, sugarsUnit: "gr", sugarsValue: 1.0)), status: 1, statusVerbose: ""), selectedServing: .constant(.gr100), selectedMeal: .constant(.breakfast), quantityServing: .constant(1), addIsEnabled: .constant(false))
    }
}
