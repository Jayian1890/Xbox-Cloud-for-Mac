//
//  ContentView.swift
//  xCloud
//
//  Created by Jared T on 2/5/23.
//

import SwiftUI
import WebKit

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
                    Menu {
                        Button(action: { record() }) {
                            Label("Record to file", systemImage: "doc")
                        }
                    }
                label: {
                    Label("Media", systemImage: "plus")
                }
                }
            }
    }
    
    func record() {
        contentRecorder.record()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
