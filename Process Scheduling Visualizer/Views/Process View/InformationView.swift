//
//  InformationView.swift
//  Process Scheduling Visualizer
//
//  Created by Jody Kocis on 4/29/21.
//

import SwiftUI

struct InformationView: View {
    @ObservedObject var processViewModel: ProcessViewModel
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                Text("Process Information")
                    .font(.headline)
                Spacer()
            }
            .padding(.horizontal)
            .padding(.bottom, 5)
            
            VStack(alignment: .center) {
                Text("Average Turn Around Time - \(processViewModel.averageTurnAroundTime)")
                Text("Average Waiting Time - \(processViewModel.averageWaitingTime)")
            }
            .padding(.bottom, 5)
            
            HStack(spacing: 15) {
                // Color
                VStack(alignment: .center) {
                    Text("Process")
                    ForEach(Array(processViewModel.allProcess.enumerated()), id: \.offset) { index, process in
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
                    ForEach(Array(processViewModel.allProcess.enumerated()), id: \.offset) { index, process in
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
                    Text("Duration")
                    ForEach(Array(processViewModel.allProcess.enumerated()), id: \.offset) { index, process in
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
                    ForEach(Array(processViewModel.allProcess.enumerated()), id: \.offset) { index, process in
                        if let processInformation = process.processInformation {
                            Text("\(processInformation.completionTime)")
                                .frame(height: 15)
                                .padding(.vertical, 1)
                        }
                    }
                    Spacer()
                }
                // Turn Around Time
                VStack(alignment: .center) {
                    Text("Turn Around Time")
                    ForEach(Array(processViewModel.allProcess.enumerated()), id: \.offset) { index, process in
                        if let processInformation = process.processInformation {
                            Text("\(processInformation.turnAroundTime)")
                                .frame(height: 15)
                                .padding(.vertical, 1)
                        }
                    }
                    Spacer()
                }
                // Waiting Time
                VStack(alignment: .center) {
                    Text("Waiting Time")
                    ForEach(Array(processViewModel.allProcess.enumerated()), id: \.offset) { index, process in
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
        }
    }
}
