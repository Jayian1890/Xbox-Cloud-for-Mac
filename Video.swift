//
//  Video.swift
//  Xbox Cloud
//
//  Created by Jared T on 2/22/23.
//

import SwiftUI
import AVFoundation

class Video: NSObject, AVCaptureFileOutputRecordingDelegate {
   
    var isActive: Bool = false
    
    var isConfigured: Bool = false
    
    let session = AVCaptureSession()
    
    let output = AVCaptureMovieFileOutput()
    
    func Configure() {
        let displayId = CGMainDisplayID()
        guard let input = AVCaptureScreenInput(displayID: displayId) else { return }
        input.minFrameDuration = CMTimeMake(value: 1, timescale: 60)
        
        let window = NSApplication.shared.mainWindow!
        
        guard let contentView = window.contentView else {
            print("window has no content view. aborting.")
            return
        }
        let contentRect = contentView.bounds
        let screenRect = window.convertToScreen(contentRect)

        let menuBarHeight = NSApp.mainMenu?.menuBarHeight ?? 0
        let capturedRect = CGRect(x: screenRect.origin.x, y: screenRect.origin.y - menuBarHeight - 5, width: screenRect.width, height: screenRect.height - menuBarHeight)

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
        
        isConfigured = true
    }
    
    func StartCapture() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMMdd_HHmmss"
        let dateString = dateFormatter.string(from: Date())
        
        let documentsPath = NSSearchPathForDirectoriesInDomains(.downloadsDirectory, .userDomainMask, true)[0] as String
        let outputPath = "\(documentsPath)/\(dateString).mp4"
        let outputFileURL = NSURL(fileURLWithPath: outputPath)

        isActive = true
        output.startRecording(to: outputFileURL as URL, recordingDelegate: self)
    }
    
    func StopCapture() {
        isActive = false
        output.stopRecording()
        Dispose()
    }
    
    internal func fileOutput(_ output: AVCaptureFileOutput, didStartRecordingTo fileURL: URL, from connections: [AVCaptureConnection]) {
        print("started recording video to \(fileURL)")
    }

    internal func fileOutput(_ output: AVCaptureFileOutput, didFinishRecordingTo outputFileURL: URL, from connections: [AVCaptureConnection], error: Error?) {
        print("stopped recording video")
    }

    func Dispose() {
        session.stopRunning()
    }
}
