//
//  ContentView.swift
//  xCloud
//
//  Created by Jared T on 2/5/23.
//

import SwiftUI

/// The main View for displaying and handling the primary app window.
struct ContentView: View {

    private let video = Video()
    
    private let webClient = WebClient()
    
    @State private var videoButtonColor = Color.gray
    
    var body: some View {
        WebClient()
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button(action: { recordVideo() }) {
                        Label("Record", systemImage: "video.circle").labelStyle(.titleAndIcon).foregroundColor(videoButtonColor)
                    }.keyboardShortcut(KeyEquivalent("r"), modifiers: .command)
                }
                ToolbarItem(placement: .primaryAction) {
                    Button(action: {
                        Screenshot().takeSnapshot(webview: WebClient.webView)
                    }) {
                        Label("Screenshot", systemImage: "photo.circle").labelStyle(.titleAndIcon)
                    }.keyboardShortcut(KeyEquivalent("s"), modifiers: .command)
                }
            }
    }
    
    func recordVideo() {
        Task {
            video.toggle()
            if video.isActive {
                videoButtonColor = Color.red
            } else {
                videoButtonColor = Color.gray
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
