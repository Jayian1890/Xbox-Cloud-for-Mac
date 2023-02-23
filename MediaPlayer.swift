//
//  Media.swift
//  Xbox Cloud
//
//  Created by Jared T on 2/22/23.
//

import AVFoundation

class MediaPlayer {
    
    private static var audioPlayer: AVAudioPlayer?
    
    private static func playAudio(resource: String) {
        let path = Bundle.main.path(forResource: resource, ofType: "wav")!
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: path))
            
        } catch {
            print("Error loading sound file: \(error.localizedDescription)")
        }
        
        DispatchQueue.main.async {
            audioPlayer?.play()
        }
    }
    
    static func Video() {
        MediaPlayer.playAudio(resource: "video")
    }
    
    static func Screenshot() {
        MediaPlayer.playAudio(resource: "screenshot")
    }
}
