//
//  WebView.swift
//  xCloud
//
//  Created by Jared T on 2/5/23.
//

import SwiftUI
import WebKit
import Combine

class WebViewData: ObservableObject {
    @Published var loading: Bool = false
    @Published var url: URL?;
    @Published var userAgent: String = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/16.3 Safari/605.1.15"
    
    init (url: URL, customUserAgent: String) {
        self.url = url
        
        if (!customUserAgent.isEmpty) {
            self.userAgent = customUserAgent
        }
    }
}

@available(OSX 11.0, *)
struct WebView: NSViewRepresentable {
    @ObservedObject var data: WebViewData
    
    func makeNSView(context: Context) -> WKWebView {
        return context.coordinator.webView
    }
    
    func updateNSView(_ nsView: WKWebView, context: Context) {
        
        guard context.coordinator.loadedUrl != data.url else { return }
        context.coordinator.loadedUrl = data.url
        
        if let url = data.url {
            DispatchQueue.main.async {
                let request = URLRequest(url: url)
                nsView.customUserAgent = data.userAgent;
                nsView.load(request)
                
                context.coordinator.data.url = data.url
            }
        }
    }
    
    func makeCoordinator() -> WebViewCoordinator {
        return WebViewCoordinator(data: data)
    }
}

@available(OSX 11.0, *)
class WebViewCoordinator: NSObject, WKNavigationDelegate {
    @ObservedObject var data: WebViewData
    
    public static var WebView: WKWebView = WKWebView()
    
    var webView: WKWebView = WKWebView()
    var loadedUrl: URL? = nil
    
    init(data: WebViewData) {
        self.data = data
        
        super.init()
        WebViewCoordinator.WebView = webView
        
        webView.navigationDelegate = self
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        DispatchQueue.main.async {
            self.data.loading = false
        }
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        DispatchQueue.main.async { self.data.loading = true }
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        showError(title: "Navigation Error", message: error.localizedDescription)
        DispatchQueue.main.async { self.data.loading = false }
    }
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        showError(title: "Loading Error", message: error.localizedDescription)
        DispatchQueue.main.async { self.data.loading = false }
    }
    
    
    func showError(title: String, message: String) {
#if os(macOS)
        let alert: NSAlert = NSAlert()
        
        alert.messageText = title
        alert.informativeText = message
        alert.alertStyle = .warning
        
        alert.runModal()
#else
        print("\(title): \(message)")
#endif
    }
}
