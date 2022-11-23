//
//  TabBarView.swift
//  MyFitnessPal
//
//  Created by Nicola Rigoni on 14/11/22.
//

import SwiftUI

struct TabBarView: View {
    @StateObject private var vm: TabBarViewModel = TabBarViewModel()
    
    var body: some View {
        TabView {
            DashboardView(vm: vm)
                .tabItem {
                    Label("Dashboard", systemImage: "rectangle.3.group")
                }
            DiaryView(vm: vm)
                .tabItem {
                    Label("Diary", systemImage: "book")
                }
            Text("Newsfeed")
                .tabItem {
                    Label("Newsfeed", systemImage: "newspaper")
                }
            Text("Settings")
                .tabItem {
                    Label("Settings", systemImage: "person")
                }
        }
    }
}

struct TabBarView_Previews: PreviewProvider {
    static var previews: some View {
        TabBarView()
    }
}
