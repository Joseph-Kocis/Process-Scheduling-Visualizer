//
//  ProcessViewModel.swift
//  Process Scheduling Visualizer
//
//  Created by Jody Kocis on 4/26/21.
//

import SwiftUI

class ProcessViewModel: ObservableObject {
    @Published var allProcess: [Process] = []
    @Published var selectedAlgorithm: SchedulingAlgorithms = .firstComeFirstServed
    
    func addProcess(arrivalTime: Int, duration: Int, priority: Int) {
        var newProcess = Process(arrivalTime: arrivalTime, duration: duration, priority: priority)
        while (allProcess.contains(where: { $0.color == newProcess.color })) {
            newProcess.color = Color(.random)
        }
        allProcess.append(newProcess)
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
