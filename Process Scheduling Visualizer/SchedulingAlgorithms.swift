//
//  SchedulingAlgorithms.swift
//  Process Scheduling Visualizer
//
//  Created by Jody Kocis on 4/27/21.
//

import SwiftUI

enum SchedulingAlgorithms: String, Equatable, CaseIterable {
    case firstComeFirstServed = "First Come First Served (FCFS)"
    case shortestJobFirst = "Shortest Job First (SJF)"
    case shortestTimeToCompletionFirst = "Shortest Time to Completion First (STCF)"
    case roundRobin = "Round Robin (RR)"
    case shortestRemaingTimeFirst = "Shortest Remaining Time First (SRTF)"
    case priority = "Priority"
    
    init?(id: Int) {
        switch id {
            case 1:
                self = .firstComeFirstServed
            case 2:
                self = .shortestJobFirst
            case 3:
                self = .shortestTimeToCompletionFirst
            case 4:
                self = .roundRobin
            case 5:
                self = .shortestRemaingTimeFirst
            case 6:
                self = .priority
            default:
                return nil
        }
    }
}
