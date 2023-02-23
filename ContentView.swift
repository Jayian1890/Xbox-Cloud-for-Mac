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
    
    var body: some View {
        WebClient()
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button(action: {
                        Task { video.toggle() }
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
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
