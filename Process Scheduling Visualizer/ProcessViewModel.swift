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
    @Published var averageWaitingTime = 0
    @Published var averageTurnAroundTime = 0
    @Published var loading = false
    
    func addProcess(arrivalTime: Int, duration: Int, priority: Int) {
        var newProcess = Process(arrivalTime: arrivalTime, duration: duration, priority: priority)
        while (allProcess.contains(where: { $0.color == newProcess.color }) || newProcess.color == .black) {
            newProcess.color = Color(.random)
        }
        allProcess.append(newProcess)
        generate()
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
        generate()
    }
    
    func deleteProcess(withId id: String) {
        for (index, process) in allProcess.enumerated() {
            if process.id.uuidString == id {
                allProcess.remove(at: index)
                break
            }
        }
        generate()
    }
    
    func generate() {
        loading = true
        scheduledProcesses = []
        DispatchQueue.global(qos: .userInitiated).async { [self] in
            var scheduledProcesses: [Process]
            switch selectedAlgorithm {
                case .firstComeFirstServed:
                    scheduledProcesses = firstComeFirstServed()
                case .shortestJobFirst:
                    scheduledProcesses = shortestJobFirst()
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
    
    private func calculateStats() {
        // Calculate the information for each process
        for (index, process) in allProcess.enumerated() {
            let arrivalTime = process.arrivalTime
            let duration = process.duration
            var completionTime = 0
            var turnAroundTime = 0
            var waitingTime = 0
            
            for (foundIndex, foundProcess) in scheduledProcesses.enumerated() {
                if foundProcess.color == process.color {
                    completionTime = foundIndex
                }
            }
            turnAroundTime = completionTime - arrivalTime
            
            for foundIndex in arrivalTime ..< completionTime {
                if scheduledProcesses[foundIndex].color != process.color {
                    waitingTime += 1
                }
            }
            
            allProcess[index].processInformation = ProcessInformation(
                arrivalTime: arrivalTime,
                duration: duration,
                completionTime: completionTime,
                turnAroundTime: turnAroundTime,
                waitingTime: waitingTime
            )
        }
        
        // Calculate the average waiting time and average turnaround time
        var averageWaitingTime = 0
        var averageTurnaroundTime = 0
        for process in allProcess {
            averageWaitingTime += process.processInformation?.waitingTime ?? 0
            averageTurnaroundTime += process.processInformation?.turnAroundTime ?? 0
        }
        averageWaitingTime /= allProcess.count
        averageTurnaroundTime /= allProcess.count
        self.averageWaitingTime = averageWaitingTime
        self.averageTurnAroundTime = averageTurnaroundTime
    }
    
    // MARK: -- Scheduling Algorithms
    
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
                    if let currentShortest = currentShortestIndex {
                        if process.duration < sortedProcesses[currentShortest].duration {
                            currentShortestIndex = index
                        }
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
    
    private func roundRobin() -> [Process] {
        var sortedProcesses: [Process] = []
        sortedProcesses.append(contentsOf: allProcess)
        sortedProcesses.sort(by: { first, second in
            return first.arrivalTime < second.arrivalTime
        })
        
        var currentSecond = 0
        var scheduledProcesses: [Process] = []
        while !sortedProcesses.isEmpty {
            // Run one second from everything that can run
            for (index, process) in sortedProcesses.enumerated() {
                if process.arrivalTime > currentSecond {
                    break
                } else {
                    // Run this process
                    let process = sortedProcesses[index]
                    scheduledProcesses.append(
                        Process(
                            color: process.color,
                            arrivalTime: process.arrivalTime,
                            duration: process.duration,
                            priority: process.priority
                        )
                    )
                    currentSecond += 1
                    sortedProcesses[index].duration -= 1
                    if sortedProcesses[index].duration <= 0 {
                        sortedProcesses.remove(at: index)
                    }
                }
            }
        }
        
        return scheduledProcesses
    }
    
    private func shortestRemainingTimeFirst() -> [Process] {
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
                    if let currentShortest = currentShortestIndex {
                        if process.duration < sortedProcesses[currentShortest].duration {
                            currentShortestIndex = index
                        }
                    } else {
                        currentShortestIndex = index
                    }
                }
            }
            if let currentShortestIndex = currentShortestIndex {
                // Run this process
                let process = sortedProcesses[currentShortestIndex]
                scheduledProcesses.append(
                    Process(
                        color: process.color,
                        arrivalTime: process.arrivalTime,
                        duration: process.duration,
                        priority: process.priority
                    )
                )
                currentSecond += 1
                sortedProcesses[currentShortestIndex].duration -= 1
                if sortedProcesses[currentShortestIndex].duration <= 0 {
                    sortedProcesses.remove(at: currentShortestIndex)
                }
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
    
    private func priority() -> [Process] {
        var sortedProcesses: [Process] = []
        sortedProcesses.append(contentsOf: allProcess)
        sortedProcesses.sort(by: { first, second in
            return first.arrivalTime < second.arrivalTime
        })
        
        var currentSecond = 0
        var scheduledProcesses: [Process] = []
        while !sortedProcesses.isEmpty {
            var currentHighestPriorityIndex: Int? = nil
            for (index, process) in sortedProcesses.enumerated() {
                if process.arrivalTime <= currentSecond {
                    if let currentHighestPriority = currentHighestPriorityIndex {
                        if process.priority > sortedProcesses[currentHighestPriority].priority {
                            currentHighestPriorityIndex = index
                        }
                    } else {
                        currentHighestPriorityIndex = index
                    }
                }
            }
            if let currentShortestIndex = currentHighestPriorityIndex {
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
}
