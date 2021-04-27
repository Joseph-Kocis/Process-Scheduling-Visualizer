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
        List {
            ForEach(processViewModel.allProcess) { process in
                Text("Process")
            }
        }
        .listStyle(SidebarListStyle())
    }
}
