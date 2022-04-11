//
//  PlayerButton.swift
//  CrossfadePlayer
//
//  Created by Admin on 08.04.2022.
//

import UIKit

class PlayerButton: UIButton {

    var currentState: ButtonState = .empty {
        didSet {
            switch currentState {
            case .play, .empty:
                isSelected = false
            case .stop, .filled:
                isSelected = true
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }

    func setupView() {
        prepareForAutoLayout()
        configuration = .gray()
    }

}

enum ButtonState {
    case play
    case stop
    case empty
    case filled
}
