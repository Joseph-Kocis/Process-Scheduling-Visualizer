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
    @Published var scheduledProcesses: [Process] = []
    
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
                firstComeFirstServed()
                calculateStats()
            case .shortestJobFirst:
                shortestJobFirst()
                calculateStats()
            case .roundRobin:
                roundRobin()
                calculateStats()
            case .shortestRemaingTimeFirst:
                shortestRemainingTimeFirst()
                calculateStats()
            case .priority:
                priority()
                calculateStats()
        }
    }
    
    private func firstComeFirstServed() {
        
    }
    
    private func shortestJobFirst() {
        
    }
    
    private func roundRobin() {
        
    }
    
    private func shortestRemainingTimeFirst() {
        
    }
    
    private func priority() {
        
    }
    
    private func calculateStats() {
        
    }
}
