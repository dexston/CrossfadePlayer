//
//  AppConstants.swift
//  CrossfadePlayer
//
//  Created by Admin on 08.04.2022.
//

import Foundation

struct K {
    
    static let title = "Crossfade player"
    static let padding = 30.0
    
    struct Button {
        static let play = "Play"
        static let stop = "Stop"
        static let firstSound = "Select first sound"
        static let secondSound = "Select second sound"
    }
    
    enum Error: String {
        case noAudio = "Select at least two sounds, then click Play button."
        case shortSoundDuration = "One of the sounds is shorter than the double fade effect. Decrease the fade effect, or choose a different sound."
        case stopPlayerFirst = "Stop the player before changing the sound."
    }
    
}
