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
    
    /// Toggles the recording function on and off using the isActive Bool value
    func toggle() {
        if !isActive {
            StartCapture()
        } else {
            StopCapture()
        }
        MediaPlayer.Video()
    }
    
    /// Sets various configuration settings prior to recording.
    /// - WARNING: Requires third-party software such as Loopback for recording audio input
    func ConfigureSession() -> Bool {
        if isConfigured {
            return isConfigured
        }
        
        if let input = AVCaptureScreenInput(displayID: CGMainDisplayID()) {
            input.minFrameDuration = CMTimeMake(value: 1, timescale: framerate)
            input.cropRect = getCapturedRect()
            
            if session.canAddInput(input) {
                session.addInput(input)
            }
        } else {
            print("Could not find a viable capture device. Aborting...")
            return isConfigured
        }
        
        if let desiredDevice = deviceDiscovery(deviceName: "Xbox Cloud") {
            do {
                let audioInput = try AVCaptureDeviceInput(device: desiredDevice)
                if session.canAddInput(audioInput) {
                    session.addInput(audioInput)
                }
            } catch {
                print("An error occurred: \(error.localizedDescription)")
                return isConfigured
            }
        }
        
        if session.canAddOutput(output) {
            session.addOutput(output)
        }
        
        print("capture session configured")
        session.startRunning()
        
        isConfigured = true
        return isConfigured
    }
    
    /// Starts capturing video
    func StartCapture() {
        guard !isActive else { return }

        if !ConfigureSession() {
            return
        }
        
        let outputFileURL = generateOutputURL()
        output.startRecording(to: outputFileURL as URL, recordingDelegate: self)
        
        isActive.toggle()
    }
    
    /// Stops recording video
    func StopCapture() {
        guard isActive else { return }
        
        resetCaptureSession()
        
        //isConfigured.toggle()
        isActive.toggle()
    }
    
    func resetCaptureSession() {
        output.stopRecording()
        session.stopRunning()
        session.removeOutput(output)
        session.addOutput(output)
        session.startRunning()
    }
    
    func generateOutputURL() -> NSURL {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMMdd_HHmmss"
        let dateString = dateFormatter.string(from: Date())
        
        let documentsPath = NSSearchPathForDirectoriesInDomains(.downloadsDirectory, .userDomainMask, true)[0] as String
        let outputPath = "\(documentsPath)/\(dateString).mp4"
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
        DispatchQueue.main.sync {
            let contentBounds = WebClient.webView.bounds
            let window = NSApplication.shared.mainWindow!
            let screenRect = window.convertToScreen(contentBounds)
            capturedRect = CGRect(x: screenRect.origin.x, y: screenRect.origin.y, width: screenRect.width, height: screenRect.height)
        }
        return capturedRect
    }
    
    internal func fileOutput(_ output: AVCaptureFileOutput, didStartRecordingTo fileURL: URL, from connections: [AVCaptureConnection]) {
        print("started recording video to \(fileURL)")
    }

    internal func fileOutput(_ output: AVCaptureFileOutput, didFinishRecordingTo outputFileURL: URL, from connections: [AVCaptureConnection], error: Error?) {
        print("stopped recording video")
    }
}
