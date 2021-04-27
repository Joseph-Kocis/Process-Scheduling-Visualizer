//
//  AddProcessView.swift
//  Process Scheduling Visualizer
//
//  Created by Jody Kocis on 4/27/21.
//

import SwiftUI

struct AddProcessView: View {
    @ObservedObject var processViewModel: ProcessViewModel
    @Environment(\.presentationMode) var presentationMode
    
    @State var showInvalidInputAlert = false
    @State var arrivalTime = ""
    @State var duration = ""
    @State var priority = ""
    
    var body: some View {
        VStack {
            Text("Add Process")
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
                Button("Add") {
                    if addProcess() {
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
        .alert(isPresented: $showInvalidInputAlert) {
            Alert(
                title: Text("Invalid Input"),
                message: Text("All values must be positive integers."),
                dismissButton: .default(Text("OK"))
            )
        }
    }
    
    func addProcess() -> Bool {
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
            processViewModel.addProcess(
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
