//
//  ProcessViewModel.swift
//  Process Scheduling Visualizer
//
//  Created by Jody Kocis on 4/26/21.
//

import SwiftUI

class ProcessViewModel: ObservableObject {
    @Published var allProcess: [Process] = [Process(arrivalTime: 0, duration: 10, priority: 0), Process(arrivalTime: 15, duration: 5, priority: 0)]
    @Published var selectedAlgorithm: SchedulingAlgorithms = .firstComeFirstServed
    @Published var scheduledProcesses: [Process] = []
    @Published var loading = false
    
    func addProcess(arrivalTime: Int, duration: Int, priority: Int) {
        var newProcess = Process(arrivalTime: arrivalTime, duration: duration, priority: priority)
        while (allProcess.contains(where: { $0.color == newProcess.color }) || newProcess.color == .black) {
            newProcess.color = Color(.random)
        }
        allProcess.append(newProcess)
    }
    
    func updateProcess(id: String, arrivalTime: Int, duration: Int, priority: Int) {
        for (index, process) in allProcess.enumerated() {
            if process.id.uuidString == id {
                allProcess[index].arrivalTime = arrivalTime
                allProcess[index].duration = duration
                allProcess[index].priority = priority
                break
            }
        }
    }
    
    func generate() {
        loading = true
        scheduledProcesses = []
        DispatchQueue.global(qos: .userInitiated).async { [self] in
            sleep(2)
            var scheduledProcesses: [Process]
            switch selectedAlgorithm {
                case .firstComeFirstServed:
                    scheduledProcesses = firstComeFirstServed()
                case .shortestJobFirst:
                    scheduledProcesses = shortestJobFirst()
                case .shortestTimeToCompletionFirst:
                    scheduledProcesses = shortestTimeToCompletionFirst()
                case .roundRobin:
                    scheduledProcesses = roundRobin()
                case .shortestRemaingTimeFirst:
                    scheduledProcesses = shortestRemainingTimeFirst()
                case .priority:
                    scheduledProcesses = priority()
            }
            DispatchQueue.main.async {
                self.scheduledProcesses = scheduledProcesses
                calculateStats()
                loading = false
            }
        }
    }
    
    private func firstComeFirstServed() -> [Process] {
        var sortedProcesses: [Process] = []
        sortedProcesses.append(contentsOf: allProcess)
        sortedProcesses.sort(by: { first, second in
            return first.arrivalTime < second.arrivalTime
        })
        
        var currentSecond = 0
        var scheduledProcesses: [Process] = []
        for process in sortedProcesses {
            while currentSecond < process.arrivalTime {
                scheduledProcesses.append(
                    Process(
                        color: Color.black,
                        arrivalTime: currentSecond,
                        duration: 1,
                        priority: 0
                    )
                )
                currentSecond += 1
            }
            for _ in 0 ..< process.duration {
                scheduledProcesses.append(
                    Process(
                        color: process.color,
                        arrivalTime: process.arrivalTime,
                        duration: process.duration,
                        priority: process.priority
                    )
                )
                currentSecond += 1
            }
        }
        return scheduledProcesses
    }
    
    private func shortestJobFirst()  -> [Process] {
        var sortedProcesses: [Process] = []
        sortedProcesses.append(contentsOf: allProcess)
        sortedProcesses.sort(by: { first, second in
            return first.arrivalTime < second.arrivalTime
        })
        
        var currentSecond = 0
        var scheduledProcesses: [Process] = []
        while !sortedProcesses.isEmpty {
            var currentShortestIndex: Int? = nil
            for (index, process) in sortedProcesses.enumerated() {
                if process.arrivalTime <= currentSecond {
                    if let currentShortest = currentShortestIndex,
                       process.duration < sortedProcesses[currentShortest].duration {
                        currentShortestIndex = index
                    } else {
                        currentShortestIndex = index
                    }
                }
            }
            if let currentShortestIndex = currentShortestIndex {
                // Run this process entirely
                let process = sortedProcesses[currentShortestIndex]
                for _ in 0 ..< process.duration {
                    scheduledProcesses.append(
                        Process(
                            color: process.color,
                            arrivalTime: process.arrivalTime,
                            duration: process.duration,
                            priority: process.priority
                        )
                    )
                    currentSecond += 1
                }
                sortedProcesses.remove(at: currentShortestIndex)
            } else {
                // Wait this time
                scheduledProcesses.append(
                    Process(
                        color: Color.black,
                        arrivalTime: currentSecond,
                        duration: 1,
                        priority: 0
                    )
                )
                currentSecond += 1
                
            }
        }
        
        return scheduledProcesses
    }
    
    private func shortestTimeToCompletionFirst() -> [Process] {
        return []
    }
    
    private func roundRobin() -> [Process] {
        return []
    }
    
    private func shortestRemainingTimeFirst() -> [Process] {
        return []
    }
    
    private func priority() -> [Process] {
        return []
    }
    
    private func calculateStats() {
        
    }
}
