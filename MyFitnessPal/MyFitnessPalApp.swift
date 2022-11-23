//
//  MyFitnessPalApp.swift
//  MyFitnessPal
//
//  Created by Nicola Rigoni on 14/11/22.
//

import SwiftUI

@main
struct MyFitnessPalApp: App {
    @State private var timer: Bool = false
    var body: some Scene {
        WindowGroup {
            TabBarView()
        }
    }
}
