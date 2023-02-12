//
//  Recorder.swift
//  xCloud
//
//  Created by Jared T on 2/9/23.
//

import SwiftUI

/// Class with functions for recording content from the main View window.
class ContentRecorder: NSViewController {
    
    /// Defines rather or not content is being recorded.
    private var isRecording = false
    
    /// Starts recording content from the main content View.
    func startRecording() {
        print("Started Recording")
        self.isRecording = true
    }
    
    /// Stops recording content from the main content View.
    func stopRecording() {
        print("Stopped recording")
        self.isRecording = false;
    }
    
    /// A toggle-style function that starts recording if it's currently inactive, and stops recording if it's currently active.
    func record() {
        if !isRecording {
            startRecording()
        } else {
            stopRecording()
        }
    }
}
