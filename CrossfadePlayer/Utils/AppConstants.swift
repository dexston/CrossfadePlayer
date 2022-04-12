//
//  AppConstants.swift
//  CrossfadePlayer
//
//  Created by Admin on 08.04.2022.
//

import Foundation
import UIKit

struct K {
    
    static let title = "Crossfade Player"
    static let padding = 15.0
    static let currentFadeValue = "Current fade duration: %.f"
    
    struct Button {
        static let play = UIImage(systemName: "play.fill")
        static let stop = UIImage(systemName: "stop.fill")
        static let firstSound = "Select first sound"
        static let secondSound = "Select second sound"
    }
    
    struct FadeSlider {
        static let minValue: Float = 2.0
        static let maxValue: Float = 10.0
        static let initialValue: Float = 4.0
    }
    
    enum Error: String {
        case noAudio = "Select at least two sounds, then click Play button."
        case shortSoundDuration = "One of the sounds is shorter than the double fade effect. Decrease the fade effect, or choose a different sound."
        case stopPlayerFirst = "Stop the player before changing the sound."
    }
    
}
