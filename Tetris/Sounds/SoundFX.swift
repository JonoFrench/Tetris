//
//  SoundFX.swift
//  Tetris
//
//  Created by Jonathan French on 6.12.25.
//

import Foundation
import AVFoundation

// MARK: - Sound Types
private enum SoundType {
    case effect
    case background
    case music
    
    var volume: Float {
        switch self {
        case .effect: return GameConstants.Sound.effectsVolume
        case .background: return GameConstants.Sound.backgroundVolume
        case .music: return GameConstants.Sound.musicVolume
        }
    }
}

// MARK: - Sound Asset Names
private enum SoundAsset {
    static let background = "rasputin"
    static let rowclear = "whoosh"
}

final class SoundFX {
    // MARK: - Properties
    private var audioPlayers: [String: AVAudioPlayer] = [:]
    private let audioExtension = "mp3"
    
    // MARK: - Initialization
    init() {
        setupAudioSession()
        loadSoundAssets()
    }
    
    private func setupAudioSession() {
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print("Failed to setup audio session: \(error.localizedDescription)")
        }
    }
    
    private func loadSoundAssets() {
        // Load effects
        loadSound(SoundAsset.rowclear, type: .effect)
        
        // Load background music
        loadSound(SoundAsset.background, type: .background)
    }
    
    private func loadSound(_ name: String, type: SoundType) {
        guard let url = Bundle.main.url(forResource: name, withExtension: audioExtension) else {
            print("Failed to find sound file: \(name).\(audioExtension)")
            return
        }
        
        do {
            let player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.m4a.rawValue)
            player.volume = type.volume
            audioPlayers[name] = player
        } catch {
            print("Failed to load sound \(name): \(error.localizedDescription)")
        }
    }
    
    // MARK: - Playback Control
    @objc private func play(audioPlayer: AVAudioPlayer) {
        audioPlayer.play()
    }
    
    private func playOnNewThread(_ name: String, loops: Int = 0) {
        guard let player = audioPlayers[name] else { return }
        player.numberOfLoops = loops
        Thread.detachNewThreadSelector(#selector(play), toTarget: self, with: player)
    }
    
    private func stop(_ name: String) {
        audioPlayers[name]?.stop()
    }
    
    // MARK: - Public Interface
    func clearRowSound() { playOnNewThread(SoundAsset.rowclear) }
    // MARK: - Background Music
    func backgroundSound() { playOnNewThread(SoundAsset.background, loops: -1) }
    

    
}
