//
//  Player.swift
//  CrossfadePlayer
//
//  Created by Admin on 08.04.2022.
//

import Foundation
import AVFAudio

class Player {
    
    private var player: AVAudioPlayer
    private var fadeOutTimer: Timer?
    private let onFadeOutBegins: () -> Void
    private var wasPaused = false
    
    init(url: URL, onFadeOutBegins: @escaping () -> Void) {
        do {
            player = try AVAudioPlayer(contentsOf: url)
        } catch {
            player = AVAudioPlayer()
            print("Player preparation failed: \(error)")
        }
        self.onFadeOutBegins = onFadeOutBegins
    }
    
    deinit {
        player.stop()
        fadeOutTimer?.invalidate()
    }
    
    func play(with fadeDuration: TimeInterval) {
        let safeFadeDuration = safeFadeDuration(fadeDuration)
        let playTimeLeft = player.duration - player.currentTime - safeFadeDuration
        if !wasPaused {
            player.volume = .zero
        }
        player.play()
        wasPaused = false
        player.setVolume(1.0, fadeDuration: safeFadeDuration)
        fadeOutTimer = Timer.scheduledTimer(withTimeInterval: playTimeLeft, repeats: false) {[weak self] _ in
            guard let self = self else { return }
            self.player.setVolume(.zero, fadeDuration: safeFadeDuration)
            self.onFadeOutBegins()
        }
    }
    
    func stop() {
        player.stop()
        fadeOutTimer?.invalidate()
    }
    
    func pause() {
        player.pause()
        wasPaused = true
        fadeOutTimer?.invalidate()
    }
    
    private func safeFadeDuration(_ fadeDuration: TimeInterval) -> TimeInterval {
        if player.duration < 2 * fadeDuration {
            return player.duration / 2
        }
        return fadeDuration
    }
}
