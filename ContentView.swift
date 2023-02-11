//
//  ContentView.swift
//  xCloud
//
//  Created by Jared T on 2/5/23.
//

import SwiftUI
import WebKit

struct ContentView: View {
    private var url: URL? = URL(string: "https://xbox.com/play")
    
    private var userAgent: String = ""
    
    private var contentRecorder: ContentRecorder = ContentRecorder()
    
    var body: some View {
        WebView(data: WebViewData(url: self.url!, customUserAgent: userAgent))
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Menu {
                        Button(action: { recordContent() }) {
                            Label("Record to file", systemImage: "video")
                        }
                    }
                label: {
                    Label("Media", systemImage: "plus")
                }
                }
            }
    }
    
    func recordContent() {
        contentRecorder.recordButtonToggle()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
