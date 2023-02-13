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
    private var contentRecorder: ContentRecorder = ContentRecorder()
    
    var body: some View {
        WebView(data: WebViewData(url: self.url!, customUserAgent: self.userAgent))
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button(action: { record() }) {
                        Label("Record", systemImage: "video.circle").labelStyle(.titleAndIcon)
                    }
                }
                ToolbarItem(placement: .primaryAction) {
                    Button(action: { screenshot() }) {
                        Label("Screenshot", systemImage: "photo.circle").labelStyle(.titleAndIcon)
                    }
                }
            }
    }
    
    /// Captures video frames of the current content within View
    /// - warning:  Not imlpemented
    func record() {
        Task {
            //await contentRecorder.record()
        }
    }
    
    /// Captures a screenshot of the current View
    /// - warning: Not implemented
    func screenshot() {
        Task {
            //not implemented
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
