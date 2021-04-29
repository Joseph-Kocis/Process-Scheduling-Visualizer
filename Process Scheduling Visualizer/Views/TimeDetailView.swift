//
//  TimeDetailView.swift
//  Process Scheduling Visualizer
//
//  Created by Jody Kocis on 4/29/21.
//

import SwiftUI

struct TimeDetailView: View {
    @ObservedObject var processViewModel: ProcessViewModel
    @Environment(\.presentationMode) var presentationMode
    
    let index: Int
    let scheduledProcessesSubset: [Process]
    
    init(processViewModel: ProcessViewModel, index: Int) {
        self.processViewModel = processViewModel
        self.index = index
        self.scheduledProcessesSubset = processViewModel.calculateStats(forIndex: index)
    }
    
    var body: some View {
        ScrollView {
            VStack {
                HStack {
                    Spacer()
                    Text("Time - \(index)")
                        .font(.headline)
                    Spacer()
                }
                .padding(.horizontal)
                .padding(.bottom, 5)
                
                HStack(spacing: 15) {
                    // Color
                    VStack(alignment: .center) {
                        Text("Process")
                        ForEach(Array(scheduledProcessesSubset.enumerated()), id: \.offset) { index, process in
                            if let _ = process.processInformation {
                                Text("00")
                                    .frame(width: 15, height: 15)
                                    .foregroundColor(.clear)
                                    .background(RoundedCorners(color: process.color, tl: 3, tr: 3, bl: 3, br: 3))
                                    .padding(.vertical, 1)
                            }
                        }
                        Spacer()
                    }
                    // Arrival Time
                    VStack(alignment: .center) {
                        Text("Arrival Time")
                        ForEach(Array(scheduledProcessesSubset.enumerated()), id: \.offset) { index, process in
                            if let processInformation = process.processInformation {
                                Text("\(processInformation.arrivalTime)")
                                    .frame(height: 15)
                                    .padding(.vertical, 1)
                            }
                        }
                        Spacer()
                    }
                    // Duration
                    VStack(alignment: .center) {
                        Text("Remaining Duration")
                        ForEach(Array(scheduledProcessesSubset.enumerated()), id: \.offset) { index, process in
                            if let processInformation = process.processInformation {
                                Text("\(processInformation.duration)")
                                    .frame(height: 15)
                                    .padding(.vertical, 1)
                            }
                        }
                        Spacer()
                    }
                    // Completion Time
                    VStack(alignment: .center) {
                        Text("Completion Time")
                        ForEach(Array(scheduledProcessesSubset.enumerated()), id: \.offset) { index, process in
                            if let processInformation = process.processInformation {
                                Text("\(processInformation.completionTime == -1 ? "-" : "\(processInformation.completionTime)")")
                                    .frame(height: 15)
                                    .padding(.vertical, 1)
                            }
                        }
                        Spacer()
                    }
                    // Turn Around Time
                    VStack(alignment: .center) {
                        Text("Turn Around Time")
                        ForEach(Array(scheduledProcessesSubset.enumerated()), id: \.offset) { index, process in
                            if let processInformation = process.processInformation {
                                Text("\(processInformation.turnAroundTime == -1 ? "-" : "\(processInformation.turnAroundTime)")")
                                    .frame(height: 15)
                                    .padding(.vertical, 1)
                            }
                        }
                        Spacer()
                    }
                    // Waiting Time
                    VStack(alignment: .center) {
                        Text("Waiting Time")
                        ForEach(Array(scheduledProcessesSubset.enumerated()), id: \.offset) { index, process in
                            if let processInformation = process.processInformation {
                                Text("\(processInformation.waitingTime)")
                                    .frame(height: 15)
                                    .padding(.vertical, 1)
                            }
                        }
                        Spacer()
                    }
                }
                .padding(.horizontal)
                
                Button("OK") {
                    presentationMode.wrappedValue.dismiss()
                }
                .keyboardShortcut(.defaultAction)
            }
            .padding()
        }
        .frame(maxHeight: 900)
    }
}

