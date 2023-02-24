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
    func ConfigureSession() {
        let displayId = CGMainDisplayID()
        guard let input = AVCaptureScreenInput(displayID: displayId) else { return }
        input.minFrameDuration = CMTimeMake(value: 1, timescale: framerate)
        
        let window = NSApplication.shared.mainWindow!
        
        let contentRect = WebClient.webView.bounds
        let screenRect = window.convertToScreen(contentRect)

        let capturedRect = CGRect(x: screenRect.origin.x, y: screenRect.origin.y, width: screenRect.width, height: screenRect.height)

        input.cropRect = capturedRect

        if session.canAddInput(input) {
            session.addInput(input)
        }
        
        let discoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInMicrophone], mediaType: AVMediaType.audio, position: .unspecified)
        
        let desiredDeviceName = "Xbox Cloud"
        var desiredDevice: AVCaptureDevice?
        for device in discoverySession.devices {
            if device.localizedName == desiredDeviceName {
                desiredDevice = device
                break
            }
        }
        
        if let desiredDevice = desiredDevice {
            do {
                let audioInput = try AVCaptureDeviceInput(device: desiredDevice)
                
                if session.canAddInput(audioInput) {
                    session.addInput(audioInput)
                }
            } catch {}
        } else {
            print("audio device 'Xbox Cloud' not found. Proceeding without audio.")
        }
        
        if session.canAddOutput(output) {
            session.addOutput(output)
        }
        
        session.startRunning()
        print("capture session configured")
        
        isConfigured.toggle()
    }
    
    /// Starts capturing video
    func StartCapture() {
        guard !isActive else { return }

        ConfigureSession()
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMMdd_HHmmss"
        let dateString = dateFormatter.string(from: Date())
        
        let documentsPath = NSSearchPathForDirectoriesInDomains(.downloadsDirectory, .userDomainMask, true)[0] as String
        let outputPath = "\(documentsPath)/\(dateString).mp4"
        let outputFileURL = NSURL(fileURLWithPath: outputPath)

        output.startRecording(to: outputFileURL as URL, recordingDelegate: self)
        
        isActive.toggle()
    }
    
    /// Stops recording video
    func StopCapture() {
        guard isActive else { return }
        
        output.stopRecording()
        session.stopRunning()
        
        output = AVCaptureMovieFileOutput()
        session = AVCaptureSession()
        
        isConfigured.toggle()
        isActive.toggle()
    }
    
    internal func fileOutput(_ output: AVCaptureFileOutput, didStartRecordingTo fileURL: URL, from connections: [AVCaptureConnection]) {
        print("started recording video to \(fileURL)")
    }

    internal func fileOutput(_ output: AVCaptureFileOutput, didFinishRecordingTo outputFileURL: URL, from connections: [AVCaptureConnection], error: Error?) {
        print("stopped recording video")
    }
}
