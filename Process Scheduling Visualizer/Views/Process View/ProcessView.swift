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
            
            ScrollView {
                VStack {
                    Spacer()
                    if processViewModel.loading {
                        HStack {
                            Spacer()
                            ProgressView()
                            Spacer()
                        }
                        .padding(.top, 300)
                    } else {
                        if processViewModel.scheduledProcesses.isEmpty {
                            HStack {
                                Spacer()
                                Text("Run Scheduling Algorithm")
                                Spacer()
                            }
                            .padding(.top, 300)
                        } else {
                            VStack(spacing: 25) {
                                if processViewModel.scheduledProcesses.count > 20 {
                                    ScrollView(.horizontal, showsIndicators: false) {
                                        BarView(processViewModel: processViewModel)
                                            .padding(.top, 50)
                                    }
                                    .frame(minWidth: 800, maxWidth: .infinity)
                                } else {
                                    BarView(processViewModel: processViewModel)
                                        .padding(.top, 50)
                                }
                                InformationView(processViewModel: processViewModel)
                            }
                        }
                    }
                    Spacer()
                }
            }
            .background(Color(NSColor.controlBackgroundColor).ignoresSafeArea())
            .toolbar {
                ToolbarItemGroup(placement: ToolbarItemPlacement.status) {
                    Menu {
                        ForEach(SchedulingAlgorithms.allCases, id: \.self) { algorithm in
                            Button(algorithm.rawValue) {
                                processViewModel.selectedAlgorithm = algorithm
                                processViewModel.generate()
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
                    .keyboardShortcut("t", modifiers: .command)
                    Button {
                        processViewModel.generate()
                    } label: {
                        Image(systemName: "arrow.clockwise")
                    }
                    .keyboardShortcut("r", modifiers: .command)
                    Button {
                        processViewModel.generateRandomly()
                    } label: {
                        Image(systemName: "die.face.6")
                    }
                }
            }
            .sheet(isPresented: $showAddProcessView) {
                AddProcessView(processViewModel: processViewModel)
            }
        }
        .onAppear {
            processViewModel.generate()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ProcessView()
    }
}
