//
//  EditProcessView.swift
//  Process Scheduling Visualizer
//
//  Created by Jody Kocis on 4/27/21.
//

import SwiftUI

struct EditProcessView: View {
    @ObservedObject var processViewModel: ProcessViewModel
    @Environment(\.presentationMode) var presentationMode
    
    @State var showInvalidInputAlert = false
    @State var arrivalTime: String = ""
    @State var duration: String = ""
    @State var priority: String = ""
    @State var id: String = ""
    let process: Process
    
    init(_ process: Process, processViewModel: ProcessViewModel) {
        self.processViewModel = processViewModel
        self.process = process
    }
    
    var body: some View {
        VStack {
            Text("Edit Process")
                .font(.headline)
                .padding()
            
            HStack {
                Text("Arrival Time")
                Spacer()
                TextField("0", text: $arrivalTime)
                    .frame(width: 200)
            }
            HStack {
                Text("Duration")
                Spacer()
                TextField("0", text: $duration)
                    .frame(width: 200)
            }
            if processViewModel.selectedAlgorithm == .priority {
                HStack {
                    Text("Priority")
                    Spacer()
                    TextField("0", text: $priority)
                        .frame(width: 200)
                }
            }
            
            Spacer()
            HStack {
                Button("Cancel") {
                    presentationMode.wrappedValue.dismiss()
                }
                .keyboardShortcut(.cancelAction)
                Spacer()
                Button("Update") {
                    if updateProcess() {
                        presentationMode.wrappedValue.dismiss()
                    } else {
                        showInvalidInputAlert = true
                    }
                }
                .keyboardShortcut(.defaultAction)
            }
        }
        .frame(width: 300, height: 200)
        .padding()
        .onAppear {
            self.id = process.id.uuidString
            self.arrivalTime = "\(process.arrivalTime)"
            self.duration = "\(process.duration)"
            self.priority = "\(process.priority)"
        }
        .alert(isPresented: $showInvalidInputAlert) {
            Alert(
                title: Text("Invalid Input"),
                message: Text("All values must be positive integers."),
                dismissButton: .default(Text("OK"))
            )
        }
    }
    
    func updateProcess() -> Bool {
        if let arrivalTime = Int(arrivalTime),
           let duration = Int(duration),
           arrivalTime >= 0,
           duration > 0 {
            if processViewModel.selectedAlgorithm == .priority {
                guard let priority = Int(priority),
                      priority > 0 else {
                    return false
                }
            }
            processViewModel.updateProcess(
                id: id,
                arrivalTime: arrivalTime,
                duration: duration,
                priority: Int(priority) ?? 0
            )
            return true
        } else {
            return false
        }
    }
}

