//
//  ActivityRingView.swift
//  MyFitnessPal
//
//  Created by Nicola Rigoni on 22/11/22.
//

import SwiftUI

struct ActivityRingView: View {
    let progress: Double
    
    
    var body: some View {
        Gauge(value: progress) {
            
        }
        .gaugeStyle(.accessoryCircularCapacity)
        .scaleEffect(2, anchor: .center)
        .tint(Color.green)
    }
}

struct ActivityRingView_Previews: PreviewProvider {
    static var previews: some View {
        ActivityRingView(progress: 1.0)
    }
}
