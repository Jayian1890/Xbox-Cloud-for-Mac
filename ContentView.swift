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
                    Button(action: { record() }) {
                        Label("Record", systemImage: "video.circle").labelStyle(.titleAndIcon)
                    }.keyboardShortcut(KeyEquivalent("r"), modifiers: .command)
                }
                ToolbarItem(placement: .primaryAction) {
                    Button(action: { takeSnapshot() }) {
                        Label("Screenshot", systemImage: "photo.circle").labelStyle(.titleAndIcon)
                    }.keyboardShortcut(KeyEquivalent("s"), modifiers: .command)
                }
            }
    }
    
    /// Captures video frames of the current content within View
    /// - warning:  Not imlpemented
    func record() {
        Task {
            await contentRecorder.RecordVideo()
        }
    }
    
    /// Take a snapshot of the current WKWebView
    func takeSnapshot() {
        let config = WKSnapshotConfiguration()
        WebViewCoordinator.WebView.takeSnapshot(with: config) { image, error in
            if let error = error {
                print("Error taking snapshot: \(error.localizedDescription)")
                return
            }
            
            guard let image = image else {
                print("Error taking snapshot: no image returned")
                return
            }
            
            Media.Screenshot()
            saveImage(image: image)
        }
    }
    
    /// Saves a provided image to the default Downloads directory on the system
    func saveImage(image: NSImage) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMMdd_HHmmss"
        let dateString = dateFormatter.string(from: Date())
        
        if let imageData = image.tiffRepresentation,
           let bitmapImage = NSBitmapImageRep(data: imageData),
           let jpegData = bitmapImage.representation(using: .jpeg, properties: [:]) {
            
            let paths = FileManager.default.urls(for: .downloadsDirectory, in: .userDomainMask)
            let directory = paths[0]
            
            let filename = "\(dateString).jpg"
            let fileURL = directory.appendingPathComponent(filename)
            
            do {
                try jpegData.write(to: fileURL)
                print("Saved image: \(directory)\(filename)")
            } catch {
                print("Error saving image: \(error.localizedDescription)")
            }
        }
    }

}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
