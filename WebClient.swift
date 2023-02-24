//
//  WebClient.swift
//  Xbox Cloud
//
//  Created by Jared T on 2/23/23.
//

import WebKit
import SwiftUI

struct WebClient: NSViewRepresentable {
    /// the underlaying webview of the webclient
    static var webView: WKWebView = WKWebView()
    
    /// The base/home url for the webclient to load
    private var baseURl: String = "https://xbox.com/play"
    
    /// the user agent used by the web client
    private var userAgent: String = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/16.3 Safari/605.1.15"
    
    init(webURL: String = "", userAgent: String = "") {
        if !webURL.isEmpty {
            self.baseURl = webURL
        }
        
        if !userAgent.isEmpty {
            self.userAgent = userAgent
        }
    }
    
    func makeNSView(context: Context) -> WKWebView {
        return WebClient.webView
    }
    
    func updateNSView(_ nsView: WKWebView, context: Context) {
        let request = URLRequest(url: URL(string: baseURl)!)
        nsView.customUserAgent = self.userAgent
        nsView.load(request)
    }
    
    func makeCoordinator() -> WebViewCoordinator {
        Coordinator(webView: WebClient.webView)
    }
}

class WebViewCoordinator: NSObject, WKNavigationDelegate {    
    init(webView: WKWebView) {
        WebClient.webView = webView
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print("Loaded WebView")
    }
}
