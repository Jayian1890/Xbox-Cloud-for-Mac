//
//  Video.swift
//  Xbox Cloud
//
//  Created by Jared T on 2/22/23.
//

import SwiftUI
import AVFoundation

/// A class that contains functions for recording the view/gameplay.
class Video: NSObject, AVCaptureFileOutputRecordingDelegate {
        
    /// the frames per second used recording function
    var framerate: Int32 = 60

    /// defines rather or not Video is recording
    var isActive: Bool = false
    
    /// defines rather or not Video is configured for recording.
    private var isConfigured: Bool = false
    
    private var session = AVCaptureSession()
    
    private var output = AVCaptureMovieFileOutput()
    
    private var videoInput: AVCaptureScreenInput?
            
    /// Toggles the recording function on and off using the isActive Bool value
    func toggle() {
        if !isActive {
            StartCapture()
        } else {
            StopCapture()
        }
        MediaPlayer.Video()
    }
    
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
    }
    
    /// Stops recording video
    func StopCapture() {
        guard isActive else { return }
        
        resetCaptureSession()
        
        isActive.toggle()
    }
    
    func resetCaptureSession() {
        output.stopRecording()
        session.stopRunning()
        session.removeOutput(output)
        session.addOutput(output)
    }
    
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
}
