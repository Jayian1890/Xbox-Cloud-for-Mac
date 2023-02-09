//
//  xCloudApp.swift
//  xCloud
//
//  Created by Jared T on 2/5/23.
//

import SwiftUI

@main
struct xCloudApp: App {
    private var viewController = RecorderViewController()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .commands {
            CommandMenu("Record") {
                Button("Video to file") {
                    viewController.recordButtonToggle()
                }
                    .keyboardShortcut("R", modifiers: [.command])
            }
        }
    }
}
