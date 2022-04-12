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
    
    private var currentPlayer: Player?
    private var fadingPlayer: Player?
    private var soundURLs: [URL] = []
    
    var isPlaying: Bool = false {
        didSet {
            delegate?.playerStateChanged(isPlaying)
        }
    }
    
    func addSound(from url: URL) {
        guard !soundURLs.contains(url) else {
            delegate?.errorThrown(.shortSoundDuration)
            return
        }
        soundURLs.append(url)
    }
    
    func play(with fadeDuration: Double) {
        isPlaying = true
        startRepeating(for: soundURLs, with: fadeDuration)
    }
        
    private func startRepeating(for urls: [URL], with fadeDuration: TimeInterval) {
        guard !urls.isEmpty else {
            delegate?.errorThrown(.noAudio)
            isPlaying = false
            return
        }
        var urls = urls
        let firstURL = urls.removeFirst()
        urls.append(firstURL)
        fadingPlayer = currentPlayer
        currentPlayer = Player(url: firstURL) { [weak self] in
            self?.startRepeating(for: urls, with: fadeDuration)
        }
        currentPlayer?.play(with: fadeDuration)
        isPlaying = true
    }
    
    func stop() {
        fadingPlayer = nil
        currentPlayer = nil
        isPlaying = false
    }
}
