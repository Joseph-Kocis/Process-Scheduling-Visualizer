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
        HStack(spacing: 2) {
            ForEach(Array(processViewModel.scheduledProcesses.enumerated()), id: \.offset) { index, process in
                VStack {
                    if process.color == .black {
                        Rectangle()
                            .foregroundColor(.clear)
                            .border(Color.black, width: 1)
                            .frame(height: 10)
                    } else if process == processViewModel.scheduledProcesses.first {
                        Rectangle()
                            .foregroundColor(.clear)
                            .background(RoundedCorners(color: process.color, tl: 10, tr: 0, bl: 10, br: 0))
                            .frame(height: 10)
                    } else if process == processViewModel.scheduledProcesses.last {
                        Rectangle()
                            .foregroundColor(.clear)
                            .background(RoundedCorners(color: process.color, tl: 0, tr: 10, bl: 0, br: 10))
                            .frame(height: 10)
                    } else {
                        Rectangle()
                            .foregroundColor(.clear)
                            .background(RoundedCorners(color: process.color, tl: 0, tr: 0, bl: 0, br: 0))
                            .frame(height: 10)
                    }
                    Text("\(index)")
                }
            }
        }
        .padding(.horizontal)
    }
}
