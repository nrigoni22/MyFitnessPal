//
//  DiaryView.swift
//  MyFitnessPal
//
//  Created by Nicola Rigoni on 16/11/22.
//

import SwiftUI
import HealthKit

struct DiaryView: View {
    @ObservedObject var vm: TabBarViewModel
    @State private var selectedDate = Date()
    @State private var showAddFoodSheet: Bool = false
    
    var body: some View {
        NavigationStack {
            VStack {
                if vm.breakfastFood.isEmpty && vm.lunchFood.isEmpty && vm.snackFood.isEmpty && vm.dinnerFood.isEmpty {
                    Image(systemName: "fork.knife.circle")
                        .font(.system(size: 200))
                        .foregroundColor(.secondary)
                    Text("No meal found")
                        .font(.largeTitle)
                } else {
                    List {
                        if !vm.breakfastFood.isEmpty {
                            Section(MealModel.breakfast.rawValue) {
                                ForEach(vm.breakfastFood) { food in
                                    Text(food.food.product?.name ?? "N/D")
                                }
                            }
                        }
                        
                        if !vm.lunchFood.isEmpty {
                            Section(MealModel.lunch.rawValue) {
                                ForEach(vm.lunchFood) { food in
                                    Text(food.food.product?.name ?? "N/D")
                                }
                            }
                        }
                        
                        if !vm.snackFood.isEmpty {
                            Section(MealModel.snack.rawValue) {
                                ForEach(vm.snackFood) { food in
                                    Text(food.food.product?.name ?? "N/D")
                                }
                            }
                        }
                        
                        if !vm.dinnerFood.isEmpty {
                            Section(MealModel.dinner.rawValue) {
                                ForEach(vm.dinnerFood) { food in
                                    Text(food.food.product?.name ?? "N/D")
                                }
                            }
                        }
                    }
                    .refreshable {
                        vm.getDiaryDataFromHealth(type: .quantityType(forIdentifier: .dietaryCarbohydrates)!, date: selectedDate)
                    }
                }
            }
            .navigationTitle("Diary")
            //.navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    DatePicker("", selection: $selectedDate, displayedComponents: .date)
                        .labelsHidden()
                    
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showAddFoodSheet.toggle()
                    } label: {
                        Image(systemName: "plus")
                    }

                }
            }
            .fullScreenCover(isPresented: $showAddFoodSheet) {
                AddFoodView(vm: vm)
            }
            .onAppear {
                vm.getDiaryDataFromHealth(type: .quantityType(forIdentifier: .dietaryCarbohydrates)!, date: selectedDate)
            }
            .onChange(of: selectedDate) { date in
                vm.getDiaryDataFromHealth(type: .quantityType(forIdentifier: .dietaryCarbohydrates)!, date: selectedDate)
            }
        }
    }
}

struct DiaryView_Previews: PreviewProvider {
    static var previews: some View {
        DiaryView(vm: TabBarViewModel())
    }
}
