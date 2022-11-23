//
//  DashboardView.swift
//  MyFitnessPal
//
//  Created by Nicola Rigoni on 16/11/22.
//

import SwiftUI
import HealthKit

struct DashboardView: View {
    @ObservedObject var vm: TabBarViewModel
    var body: some View {
        NavigationStack {
            ScrollView {
                HStack {
                    ZStack {
                        ActivityRingView(progress: 2)
                            .frame(width: 150, height: 150)
                        Image(systemName: "flame.fill")
                            .font(.system(size: 40))
                    }
                    
                    VStack(spacing: 20) {
                        HStack(alignment: .top, spacing: 20) {
                            VStack {
                                Text("Goal")
                                    .font(.headline)
                                Text("\(String(format: "%.1f", vm.activityGoal)) Kcal")
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                            }
                            
                            VStack {
                                Text("Food")
                                    .font(.headline)
                                Text("\(String(format: "%.1f", vm.dietaryEnergy)) Kcal")
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                            }
                            
                            VStack {
                                Text("Exercise")
                                    .font(.headline)
                                Text("\(String(format: "%.1f", vm.activityBurned)) Kcal")
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                            }
                            
                            
                            
                        }
                        VStack {
                            Text("Remaining")
                                .font(.headline)
                            Text("\(String(format: "%.1f", vm.activityGoal - vm.dietaryEnergy + vm.activityBurned)) Kcal")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                    }
                }
                
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(RoundedRectangle(cornerRadius: 10).foregroundColor(Color(UIColor.systemGroupedBackground)).shadow(radius: 5))
                .padding()
            }
            .navigationTitle("Dashboard")
            .onAppear {
                vm.getDashboardCardData()
            }
        }
        
    }
}

struct DashboardView_Previews: PreviewProvider {
    static var previews: some View {
        DashboardView(vm: TabBarViewModel())
    }
}
