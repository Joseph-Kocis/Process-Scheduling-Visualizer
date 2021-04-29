//
//  Process.swift
//  Process Scheduling Visualizer
//
//  Created by Jody Kocis on 4/26/21.
//

import SwiftUI

struct Process: Identifiable, Hashable {
    let id = UUID()
    var color = Color(.random)
    var arrivalTime: Int
    var duration: Int
    var priority: Int
    var processInformation: ProcessInformation? = nil
}

struct ProcessInformation: Equatable, Hashable {
    var arrivalTime: Int
    var duration: Int
    var completionTime: Int
    var turnAroundTime: Int
    var waitingTime: Int
}
