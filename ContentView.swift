//
//  ContentView.swift
//  xCloud
//
//  Created by Jared T on 2/5/23.
//

import SwiftUI

/// The main View for displaying and handling the primary app window.
struct ContentView: View {
    
    /// The default URL for Microsoft's Xbox Cloud service.
    private var url: URL? = URL(string: "https://xbox.com/play")
    
    /// The custom user supplied user agent. Uses safari's useragent by default.
    private var userAgent: String = ""
    
    /// A class that contains functions for recording the view/gameplay.
    private let video = Video()
    
    var body: some View {
        WebView(data: WebViewData(url: self.url!, customUserAgent: self.userAgent))
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button(action: {
                        Task {recordVideo()}
                    }) {
                        Label("Record", systemImage: "video.circle").labelStyle(.titleAndIcon)
                    }.keyboardShortcut(KeyEquivalent("r"), modifiers: .command)
                }
                ToolbarItem(placement: .primaryAction) {
                    Button(action: {
                        Screenshot().takeSnapshot(webview: WebViewCoordinator.WebView)
                    }) {
                        Label("Screenshot", systemImage: "photo.circle").labelStyle(.titleAndIcon)
                    }.keyboardShortcut(KeyEquivalent("s"), modifiers: .command)
                }
            }
    }

    func recordVideo() {
        video.Configure()
        
        if !video.isActive {
            video.StartCapture()
        } else {
            video.StopCapture()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
