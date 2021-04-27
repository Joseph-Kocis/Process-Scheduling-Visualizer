//
//  BarView.swift
//  Process Scheduling Visualizer
//
//  Created by Jody Kocis on 4/27/21.
//

import SwiftUI

struct BarView: View {
    @ObservedObject var processViewModel: ProcessViewModel
    
    var body: some View {
        HStack {
            ForEach(processViewModel.scheduledProcesses, id: \.self) { process in
                if process == processViewModel.scheduledProcesses.first {
                    Text("here")
                } else if process == processViewModel.scheduledProcesses.last {
                    Text("here")
                } else {
                    Text("here")
                }
            }
        }
    }
}
