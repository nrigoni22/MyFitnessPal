//
//  AddFoodView.swift
//  MyFitnessPal
//
//  Created by Nicola Rigoni on 17/11/22.
//

import SwiftUI

struct AddFoodView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var vm: TabBarViewModel
    @State private var scanResult: String = ""
    @State private var isLoading: Bool = false
    @State private var addIsEnabled: Bool = true
    @State private var selectedServing: ServingSize = .gr100
    @State private var selectedMeal: MealModel = .breakfast
    @State private var quantityServing: Int = 1
    
    var body: some View {
        NavigationStack {
            VStack {
                if scanResult == "" {
                    ScannerView(result: $scanResult)
                        .ignoresSafeArea()
                } else if isLoading {
                    ProgressView()
                } else if let food = vm.food {
                    FoodDataView(vm: vm, foodNutrition: food, selectedServing: $selectedServing, selectedMeal: $selectedMeal, quantityServing: $quantityServing, addIsEnabled: $addIsEnabled)
                        
                }
            }
            .navigationTitle("Scan barcode")
            .navigationBarTitleDisplayMode(.inline)
            .onChange(of: scanResult, perform: { code in
                isLoading = true
                Task {
                    await vm.getFood(barcode: "8076809512060") //"8076809512060"
                    isLoading = false
                }
            })
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        Text("Cancel")
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        vm.saveMealToHealth(selectedServing: selectedServing, selectedMeal: selectedMeal, quantityServing: quantityServing)
                        dismiss()
                    } label: {
                        Text("Add")
                    }
                    .disabled(addIsEnabled)
                }
            }
        }
    }
}

struct AddFoodView_Previews: PreviewProvider {
    static var previews: some View {
        AddFoodView(vm: TabBarViewModel())
    }
}
