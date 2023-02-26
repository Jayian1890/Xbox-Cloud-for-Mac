//
//  ContentView.swift
//  xCloud
//
//  Created by Jared T on 2/5/23.
//

import SwiftUI

/// The main View for displaying and handling the primary app window.
struct ContentView: View {
    
    private let videoCapture = VideoCapture()
    
    private let screenshot = Screenshot()

    private let webClient = WebClient()
    
    var body: some View {
        WebClient()
            .onAppear {
                DispatchQueue.main.async {
                    let mainMenu = NSApp.mainMenu
                    mainMenu?.items.removeAll()
                    
                    let baseMenuItem = NSMenuItem(title: "Xbox Cloud", action: nil, keyEquivalent: "")
                    let baseMenu = NSMenu()
                    baseMenu.addItem(withTitle: "Toggle Full Screen", action: #selector(NSApp.mainWindow?.toggleFullScreen(_:)), keyEquivalent: "f")
                    baseMenu.addItem(withTitle: "Quit", action: #selector(NSApp.terminate), keyEquivalent: "q")
                    baseMenuItem.submenu = baseMenu
                    mainMenu?.addItem(baseMenuItem)
                    
                    let fileMenu = NSMenu(title: "File")
                    
                    let subMenuItem = NSMenuItem(title: "Record Video", action: #selector(videoCapture.toggle), keyEquivalent: "r")
                    subMenuItem.target = videoCapture
                    fileMenu.addItem(subMenuItem)
                    
                    let subMenuItem2 = NSMenuItem(title: "Take Screenshot", action: #selector(screenshot.takeSnapshot), keyEquivalent: "s")
                    subMenuItem2.target = screenshot
                    fileMenu.addItem(subMenuItem2)
                    
                    let menuItem = NSMenuItem(title: "Menu2", action: nil, keyEquivalent: "")
                    menuItem.submenu = fileMenu
                    mainMenu?.addItem(menuItem)
                    
                    mainMenu?.update()
                }
                
                Task {
                    videoCapture.ConfigureSession()
                }
            }
        
            .onDisappear() {
                NSApp.terminate(self)
            }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
