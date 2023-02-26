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

    private let webClient = WebClient()
        
    @State private var videoButtonColor = Color.secondary
    
    var body: some View {
        WebClient()
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button(action: recordVideo) {
                        Label("Record", systemImage: "video.circle")
                            .labelStyle(.titleAndIcon)
                            .foregroundColor(videoButtonColor)
                    }.keyboardShortcut("r", modifiers: .command)
                }
                ToolbarItem(placement: .primaryAction) {
                    Button(action: Screenshot().takeSnapshot) {
                        Label("Screenshot", systemImage: "photo.circle")
                            .labelStyle(.titleAndIcon)
                    }.keyboardShortcut(KeyEquivalent("s"), modifiers: .command)
                }
            }
            .onAppear {
                Task {
                    videoCapture.ConfigureSession()
                }
            }
    }
    
    func recordVideo() {
        videoCapture.toggle()
        videoButtonColor = videoCapture.isActive ? .red : .secondary
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
