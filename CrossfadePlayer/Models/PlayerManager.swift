//
//  PlayerManager.swift
//  CrossfadePlayer
//
//  Created by Admin on 06.04.2022.
//

import Foundation
import AVFoundation

protocol PlayerManagerDelegate: AnyObject {
    func toggleButtons(_ value: Bool)
}

class PlayerManager {
    
    weak var delegate: PlayerManagerDelegate?
    
    private var firstPlayer = PlayerModel()
    private var secondPlayer = PlayerModel()
    
    private var fadeOutTimer: Timer?
    private var secondSoundTimer: Timer?
    
    private var globalTimer: Timer?
    
    var fadeDuration: Double?
    
    var isPlaying: Bool = false {
        didSet {
            delegate?.toggleButtons(isPlaying)
        }
    }
    
    func addFirstSound(from url: URL) {
        firstPlayer.sound = url
    }
    
    func addSecondSound(from url: URL) {
        secondPlayer.sound = url
    }
    
    func prepareAndPlay() {
        
        guard
            let firstUrl = firstPlayer.sound,
            let secondUrl = secondPlayer.sound
        else {
            print("No audio")
            return
        }
        
        firstPlayer.prepare(with: firstUrl)
        secondPlayer.prepare(with: secondUrl)
        
        play()
        isPlaying = true
    }
    
    private func playWithFade(for fadeDuration: Double, on player: AVAudioPlayer) {
        player.volume = 0.0
        player.play()
        player.setVolume(1.0, fadeDuration: fadeDuration)
        fadeOutTimer = Timer.scheduledTimer(withTimeInterval: player.duration - fadeDuration, repeats: false) { _ in
            player.setVolume(0.0, fadeDuration: fadeDuration)
        }
    }
    
    private func play() {
        
        guard
            let firstPlayer = firstPlayer.player,
            let secondPlayer = secondPlayer.player,
            let fadeDuration = fadeDuration
        else {
            return
        }

        playWithFade(for: fadeDuration, on: firstPlayer)
        secondSoundTimer = Timer.scheduledTimer(withTimeInterval: firstPlayer.duration - fadeDuration, repeats: false) { _ in
            self.playWithFade(for: fadeDuration, on: secondPlayer)
        }
        let globalDuration = firstPlayer.duration + secondPlayer.duration - 2 * fadeDuration
        globalTimer = Timer.scheduledTimer(withTimeInterval: globalDuration, repeats: false, block: { _ in
            if self.isPlaying == true {
                self.play()
            }
        })
    }
    
    func stop() {
        firstPlayer.player?.stop()
        secondPlayer.player?.stop()
        fadeOutTimer?.invalidate()
        secondSoundTimer?.invalidate()
        globalTimer?.invalidate()
        isPlaying = false
    }
}
