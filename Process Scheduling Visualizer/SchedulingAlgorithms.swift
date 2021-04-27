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
                self = .roundRobin
            case 4:
                self = .shortestRemaingTimeFirst
            case 5:
                self = .priority
            default:
                return nil
        }
    }
}
