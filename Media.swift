//
//  Media.swift
//  Xbox Cloud
//
//  Created by Jared T on 2/22/23.
//

import AVFoundation

class Media {
    
    static var audioPlayer: AVAudioPlayer?
    
    static func Screenshot() {
        let path = Bundle.main.path(forResource: "screenshot", ofType: "wav")!
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: path))
            
        } catch {
            print("Error loading sound file: \(error.localizedDescription)")
        }
        
        DispatchQueue.main.async {
            audioPlayer?.play()
        }
    }
}
