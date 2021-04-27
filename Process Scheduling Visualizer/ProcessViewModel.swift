//
//  ProcessViewModel.swift
//  Process Scheduling Visualizer
//
//  Created by Jody Kocis on 4/26/21.
//

import SwiftUI

class ProcessViewModel: ObservableObject {
    @Published var allProcess: [Process] = [Process(arrivalTime: 0, duration: 0), Process(arrivalTime: 0, duration: 0), Process(arrivalTime: 0, duration: 0)]
    @Published var selectedAlgorithm: SchedulingAlgorithms = .firstComeFirstServed
    
    func addProcess(arrivalTime: Int, duration: Int, priority: Int) {
        
    }
    
    func generate() {
        switch selectedAlgorithm {
            case .firstComeFirstServed:
                break
            case .shortestJobFirst:
                break
            case .roundRobin:
                break
            case .shortestRemaingTimeFirst:
                break
            case .priority:
                break
        }
    }
}
