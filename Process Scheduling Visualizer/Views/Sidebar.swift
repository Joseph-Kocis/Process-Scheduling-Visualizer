//
//  Sidebar.swift
//  Process Scheduling Visualizer
//
//  Created by Jody Kocis on 4/26/21.
//

import SwiftUI

struct Sidebar: View {
    @ObservedObject var processViewModel: ProcessViewModel
    
    var body: some View {
        if processViewModel.allProcess.isEmpty {
            Text("No Processes")
        } else {
            ScrollView {
                ForEach(processViewModel.allProcess) { process in
                    ZStack {
                        process.color.cornerRadius(10)
                        HStack {
                            VStack(alignment: .leading) {
                                Text("Arrival Time")
                                Text("Duration")
                                if processViewModel.selectedAlgorithm == .priority {
                                    Text("Priority")
                                }
                            }
                            Spacer()
                            VStack(alignment: .trailing) {
                                Text("\(process.arrivalTime)")
                                Text("\(process.duration)")
                                if processViewModel.selectedAlgorithm == .priority {
                                    Text("\(process.priority)")
                                }
                            }
                        }
                        .padding(.horizontal)
                        .padding(.vertical, 5)
                    }
                    .padding(.horizontal)
                }
                Spacer()
            }
        }
    }
}
