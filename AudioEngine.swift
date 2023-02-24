//
//  AudioEngine.swift
//  Xbox Cloud
//
//  Created by Jared T on 2/24/23.
//

import AVFoundation

class AudioEngine {
    private let engine = AVAudioEngine()
    private let player = AVAudioPlayerNode()
    private let inputNode: AVAudioInputNode?
    
    init?() {
        self.inputNode = engine.inputNode
        
        do {
            try self.start()
        } catch {}
    }
    
    func start() throws {
        guard let inputNode = self.inputNode else {
            throw NSError(domain: "AudioEngine", code: 1, userInfo: [NSLocalizedDescriptionKey: "Input node not available"])
        }
        let inputFormat = inputNode.inputFormat(forBus: 0)
        engine.attach(player)
        //engine.connect(inputNode, to: player, format: inputFormat)
        engine.connect(player, to: engine.outputNode, format: inputFormat)
        engine.prepare()
        try engine.start()
        player.play()
    }
    
    func stop() {
        engine.stop()
    }
}
