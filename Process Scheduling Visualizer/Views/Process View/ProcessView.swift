//
//  ProcessView.swift
//  Process Scheduling Visualizer
//
//  Created by Jody Kocis on 4/2/21.
//

import SwiftUI

struct ProcessView: View {
    @StateObject var processViewModel = ProcessViewModel()
    @State var showAddProcessView = false
    
    var body: some View {
        NavigationView {
            Sidebar(processViewModel: processViewModel)
            
            VStack {
                if processViewModel.scheduledProcesses.isEmpty {
                    Text("Run Scheduling Algorithm")
                } else {
                    BarView(processViewModel: processViewModel)
                }
            }
            .toolbar {
                ToolbarItemGroup(placement: ToolbarItemPlacement.status) {
                    Menu {
                        ForEach(SchedulingAlgorithms.allCases, id: \.self) { algorithm in
                            Button(algorithm.rawValue) {
                                processViewModel.selectedAlgorithm = algorithm
                            }
                        }
                    } label: {
                        Text(processViewModel.selectedAlgorithm.rawValue)
                    }
                }
                ToolbarItemGroup(placement: ToolbarItemPlacement.automatic) {
                    Button {
                        showAddProcessView = true
                    } label: {
                        Image(systemName: "plus")
                    }
                    Button {
                        processViewModel.generate()
                    } label: {
                        Image(systemName: "arrow.clockwise")
                    }
                    .keyboardShortcut("r", modifiers: .command)
                }
            }
            .sheet(isPresented: $showAddProcessView) {
                AddProcessView(processViewModel: processViewModel)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ProcessView()
    }
}
