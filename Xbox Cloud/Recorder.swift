//
//  Recorder.swift
//  xCloud
//
//  Created by Jared T on 2/9/23.
//

import SwiftUI
import ReplayKit

class RecorderViewController: NSViewController {
    
    @IBOutlet var recordButton: NSButton!
    
    let recorder = RPScreenRecorder.shared()
    
    @State private var isRecording = false
    
    func startRecording() {
        guard recorder.isAvailable else {
            print("Recording is not available at this time.")
            return
        }
        
        recorder.startRecording{ [unowned self] (error) in
            
            guard error == nil else {
                print("There was an error starting the recording.")
                return
            }
            
            print("Started Recording Successfully")
            self.isRecording = true
        }
    }
    
    func stopRecording() {
        recorder.stopRecording { [unowned self] (preview, error) in
            print("Stopped recording")
            
            guard preview != nil else {
                print("Preview controller is not available.")
                return
            }
            
            self.isRecording = false
        }
    }
    
    func recordButtonToggle() {
        if !isRecording {
            startRecording()
        } else {
            stopRecording()
        }
    }
    
    @IBAction func recordButtonClicked(_ sender: NSButton) {
        recordButtonToggle()
    }
}
