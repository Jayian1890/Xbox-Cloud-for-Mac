//
//  Video.swift
//  Xbox Cloud
//
//  Created by Jared T on 2/22/23.
//

import SwiftUI
import AVFoundation

/// A class that contains functions for recording the view/gameplay.
class VideoCapture: NSObject, AVCaptureFileOutputRecordingDelegate {
        
    /// the frames per second used recording function
    var framerate: Int32 = 60

    /// defines rather or not Video is recording
    var isActive: Bool = false
    
    /// defines rather or not Video is configured for recording.
    private var isConfigured: Bool = false
    
    private var session = AVCaptureSession()
    
    private var output = AVCaptureMovieFileOutput()
    
    private var videoInput: AVCaptureScreenInput?
    
    private var imageView: NSImageView = NSImageView(frame: NSRect(x: 0, y: 0, width: 25, height: 25))
            
    /// Toggles the recording function on and off using the isActive Bool value
    @objc func toggle() {
        MediaPlayer.Video()
        if !isActive {
            StartCapture()
        } else {
            StopCapture()
        }
    }
    
    /// prepares the video input for recording
    func configureVideoInput() {
        if videoInput == nil {
            videoInput = AVCaptureScreenInput(displayID: CGMainDisplayID())
        }
        
        if let input = videoInput, session.inputs.contains(input) {
            session.removeInput(input)
        }
        
        if let input = videoInput {
            input.minFrameDuration = CMTimeMake(value: 1, timescale: framerate)
            input.cropRect = getCapturedRect()
            if session.canAddInput(input) {
                session.addInput(input)
            }
        }
    }
    
    /// prepares the audio input(s) for recording
    func configureAudioInput() {
        let deviceName = "Xbox Cloud"
        
        if let desiredDevice = deviceDiscovery(deviceName: deviceName),
            let audioInput = try? AVCaptureDeviceInput(device: desiredDevice) {
            if session.canAddInput(audioInput) {
                session.addInput(audioInput)
            }
        } else {
            print("Could not find device named \(deviceName)")
            return
        }
    }
    
    /// Sets various configuration settings prior to recording.
    /// - WARNING: Requires third-party software such as Loopback for recording audio input
    func ConfigureSession() {
        guard !isConfigured else {
            print("Session already configured.")
            return
        }
        
        configureAudioInput()
        
        if session.canAddOutput(output) {
            session.addOutput(output)
        }
        
        print("capture session configured")
        isConfigured = true
    }
    
    /// Starts capturing video
    func StartCapture() {
        guard !isActive else { return }

        if !isConfigured {
            print("Please configure the session before attempting to record")
            return
        }
        
        configureVideoInput()
        
        session.startRunning()
        output.startRecording(to: generateOutputURL() as URL, recordingDelegate: self)
        
        isActive.toggle()
        showOverlay()
    }
    
    /// Stops recording video
    func StopCapture() {
        guard isActive else { return }
        
        resetCaptureSession()
        
        isActive.toggle()
        hideOverlay()
    }
    
    func resetCaptureSession() {
        output.stopRecording()
        session.stopRunning()
        session.removeOutput(output)
        session.addOutput(output)
    }
    
    /// Generates a file path string for the video file to be saved to.
    func generateOutputURL() -> NSURL {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMMdd_HHmmss"
        let dateString = dateFormatter.string(from: Date())
        
        let documentsPath = NSSearchPathForDirectoriesInDomains(.downloadsDirectory, .userDomainMask, true)[0] as String
        let outputPath = "\(documentsPath)/xboxcloud_\(dateString).mp4"
        let outputFileURL = NSURL(fileURLWithPath: outputPath)
        
        return outputFileURL
    }
    
    /// Returns a single device by name that's closest to supplied 'deviceName'
    func deviceDiscovery(deviceName: String) ->AVCaptureDevice? {
        let discoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInMicrophone], mediaType: AVMediaType.audio, position: .unspecified)
        
        let desiredDeviceName = deviceName
        var desiredDevice: AVCaptureDevice?
        for device in discoverySession.devices {
            if device.localizedName == desiredDeviceName {
                desiredDevice = device
                break
            }
        }
        
        return desiredDevice
    }
    
    /// crops the screen to a confined section of the main window for recording
    func getCapturedRect() -> CGRect {
        var capturedRect = CGRect()
        let contentBounds = WebClient.webView.bounds
        let window = getWindow()!
        let screenRect = window.convertToScreen(contentBounds)
        capturedRect = CGRect(x: screenRect.origin.x, y: screenRect.origin.y,
                              width: screenRect.width, height: screenRect.height)
        return capturedRect
    }
    
    /// Gets the main NSWindow of the app.
    /// This function sleeps until a window is available.
    func getWindow() -> NSWindow? {
        while NSApplication.shared.windows.isEmpty {
            sleep(1)
        }
        
        let windows = NSApplication.shared.windows
        return windows.first
    }

    
    internal func fileOutput(_ output: AVCaptureFileOutput, didStartRecordingTo fileURL: URL, from connections: [AVCaptureConnection]) {
        print("started recording video to \(fileURL)")
    }

    internal func fileOutput(_ output: AVCaptureFileOutput, didFinishRecordingTo outputFileURL: URL, from connections: [AVCaptureConnection], error: Error?) {
        print("stopped recording video")
    }
    
    func showOverlay() {
        var offset: CGFloat = 0
        
        if let image = NSImage(systemSymbolName: "video", accessibilityDescription: nil)?.withSymbolConfiguration(NSImage.SymbolConfiguration(pointSize: 30, weight: .medium)) {
            if let window = NSApplication.shared.windows.first {
                let isFullScreen = window.styleMask.contains(.fullScreen)
                offset = isFullScreen ? 0 : 25
            }
            
            imageView.frame.origin.y = offset
            imageView.image = image
            imageView.imageScaling = .scaleProportionallyUpOrDown
            imageView.contentTintColor = .systemRed
            imageView.canDrawSubviewsIntoLayer = true
            imageView.wantsLayer = true
            imageView.layer?.backgroundColor = NSColor.clear.cgColor
            imageView.layer?.cornerRadius = 10.0
            imageView.layer?.borderWidth = 2.0
            imageView.layer?.borderColor = NSColor.clear.cgColor
            
            NSApp.mainWindow?.contentView?.addSubview(imageView)
        }
    }
    
    func hideOverlay() {
        imageView.removeFromSuperview()
    }
}
