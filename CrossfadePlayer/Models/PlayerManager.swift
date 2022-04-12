//
//  PlayerManager.swift
//  CrossfadePlayer
//
//  Created by Admin on 06.04.2022.
//

import Foundation
import AVFoundation

protocol PlayerManagerDelegate: AnyObject {
    func playerStateChanged(_ value: Bool)
    func errorThrown(_ error: K.Error)
}

class PlayerManager {
    
    weak var delegate: PlayerManagerDelegate?
    
    private var firstPlayer = Player()
    private var secondPlayer = Player()
    
    private var nextSoundTimer: Timer?
    
    private var globalTimer: Timer?
    
    private var fadeDuration: Double = .zero
    
    var isPlaying: Bool = false {
        didSet {
            delegate?.playerStateChanged(isPlaying)
        }
    }
    
    func addFirstSound(from url: URL) {
        firstPlayer.sound = url
    }
    
    func addSecondSound(from url: URL) {
        secondPlayer.sound = url
    }
    
    func startPlaying(fadeDuration: Double) {
        
        guard
            let firstUrl = firstPlayer.sound,
            let secondUrl = secondPlayer.sound
        else {
            delegate?.errorThrown(.noAudio)
            return
        }
        
        self.fadeDuration = fadeDuration
        
        firstPlayer.prepare(with: firstUrl)
        secondPlayer.prepare(with: secondUrl)
        
        if checkDuration() {
            play()
            isPlaying = true
        } else {
            delegate?.errorThrown(.shortSoundDuration)
        }
    }
    
    private func play() {

        firstPlayer.playWithFade(for: fadeDuration)
        
        let fadeOutTime = firstPlayer.duration - fadeDuration
        nextSoundTimer = Timer.scheduledTimer(withTimeInterval: fadeOutTime, repeats: false) {[unowned self] _ in
            self.secondPlayer.playWithFade(for: self.fadeDuration)
        }
        
        let globalDuration = firstPlayer.duration + secondPlayer.duration - 2 * fadeDuration
        globalTimer = Timer.scheduledTimer(withTimeInterval: globalDuration, repeats: false, block: {[unowned self] _ in
            if self.isPlaying {
                self.play()
            }
        })
    }
    
    func stop() {
        firstPlayer.stop()
        secondPlayer.stop()
        nextSoundTimer?.invalidate()
        globalTimer?.invalidate()
        isPlaying = false
    }
    
    private func checkDuration() -> Bool {
        (firstPlayer.duration >= 2 * fadeDuration && secondPlayer.duration >= 2 * fadeDuration)
    }
}
