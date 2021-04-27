//
//  Process.swift
//  Process Scheduling Visualizer
//
//  Created by Jody Kocis on 4/26/21.
//

import SwiftUI

struct Process: Identifiable, Hashable {
    let id = UUID()
    let color = Color(.random)
    let priority = 0
    let arrivalTime: Int
    let duration: Int
}
