//
//  PlayerModel.swift
//  CrossfadePlayer
//
//  Created by Admin on 08.04.2022.
//

import Foundation
import AVFAudio

struct PlayerModel {
    var player: AVAudioPlayer?
    var sound: URL?
    
    mutating func prepare(with url: URL) {
        do {
            player = try AVAudioPlayer(contentsOf: url)
        } catch {
            print(error)
        }
    }
}
