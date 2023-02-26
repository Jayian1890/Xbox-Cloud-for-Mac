//
//  Screenshot.swift
//  Xbox Cloud
//
//  Created by Jared T on 2/22/23.
//

import WebKit

/// This class contains functions for taking and saving screenshots of the internal application
class Screenshot {
    
    /// contains configuration information for the webkit snapshot
    private let config = WKSnapshotConfiguration()
    
    /// This variable caches the most recent image taken by this class
    private var lastImage: NSImage? = nil
    
    init() {
        config.afterScreenUpdates = true
    }
    
    /// Take a snapshot of the the supplied WKWebView
    func takeSnapshot() {
        let webview = WebClient.webView
        webview.takeSnapshot(with: config) { image, error in
            if let error = error {
                print("Error taking snapshot: \(error.localizedDescription)")
                return
            }
            
            guard let image = image else {
                print("Error taking snapshot: no image returned")
                return
            }
            
            self.saveImage(image: image)
            MediaPlayer.Screenshot()

            self.lastImage = image
        }
    }
    
    /// Saves a provided image to the default Downloads directory on the system
    private func saveImage(image: NSImage) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMMdd_HHmmss"
        let dateString = dateFormatter.string(from: Date())
        
        if let imageData = image.tiffRepresentation,
           let bitmapImage = NSBitmapImageRep(data: imageData),
           let jpegData = bitmapImage.representation(using: .jpeg, properties: [:]) {
            
            let paths = FileManager.default.urls(for: .downloadsDirectory, in: .userDomainMask)
            let directory = paths[0]
            
            let filename = "xboxcloud_\(dateString).jpg"
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
