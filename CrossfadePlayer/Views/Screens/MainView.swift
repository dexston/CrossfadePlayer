//
//  MainView.swift
//  CrossfadePlayer
//
//  Created by Admin on 06.04.2022.
//

import UIKit

protocol MainViewDelegate: AnyObject {
    func soundButtonPressed(sender: PlayerButton)
    func playButtonPressed()
}

class MainView: UIView {
    
    weak var delegate: MainViewDelegate?
    
    var sliderValue: Float {
        fadeSlider.value
    }

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.prepareForAutoLayout()
        label.text = K.title
        label.font = .preferredFont(forTextStyle: .largeTitle)
        label.textAlignment = .center
        return label
    }()
    
    let firstAudioButton: PlayerButton = {
        let button = PlayerButton()
        button.currentState = .empty
        button.setTitle(K.Button.firstSound, for: .normal)
        return button
    }()
    
    let secondAudioButton: PlayerButton = {
        let button = PlayerButton()
        button.currentState = .empty
        button.setTitle(K.Button.secondSound, for: .normal)
        return button
    }()
    
    private let fadeSlider: UISlider = {
        let slider = UISlider()
        slider.prepareForAutoLayout()
        slider.minimumValue = 2.0
        slider.maximumValue = 10.0
        slider.value = 2.0
        return slider
    }()
    
    private let fadeValueLabel: UILabel = {
        let label = UILabel()
        label.prepareForAutoLayout()
        label.font = .preferredFont(forTextStyle: .body)
        label.textAlignment = .center
        return label
    }()
    
    private let playButton: PlayerButton = {
        let button = PlayerButton()
        button.currentState = .stop
        button.setTitle(K.Button.play, for: .normal)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }

    private func setupView() {
        addActions()
        backgroundColor = .systemBackground
        addSubview(titleLabel)
        addSubview(firstAudioButton)
        addSubview(secondAudioButton)
        addSubview(fadeSlider)
        addSubview(fadeValueLabel)
        addSubview(playButton)
        fadeValueLabel.text = String(format: "%.f", sliderValue)
        let safeArea = safeAreaLayoutGuide
        let constraints = [
            //TitleLabel
            titleLabel.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            titleLabel.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: K.padding),
            titleLabel.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            titleLabel.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor),
            //FirstButton
            firstAudioButton.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: K.padding),
            firstAudioButton.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: K.padding),
            firstAudioButton.trailingAnchor.constraint(equalTo: secondAudioButton.leadingAnchor, constant: -K.padding),
            firstAudioButton.heightAnchor.constraint(equalTo: safeArea.heightAnchor, multiplier: 0.1),
            //SecondButton
            secondAudioButton.topAnchor.constraint(equalTo: firstAudioButton.topAnchor),
            secondAudioButton.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -K.padding),
            secondAudioButton.bottomAnchor.constraint(equalTo: firstAudioButton.bottomAnchor),
            secondAudioButton.widthAnchor.constraint(equalTo: firstAudioButton.widthAnchor),
            //FadeSlider
            fadeSlider.leadingAnchor.constraint(equalTo: firstAudioButton.leadingAnchor),
            fadeSlider.trailingAnchor.constraint(equalTo: secondAudioButton.trailingAnchor),
            fadeSlider.topAnchor.constraint(equalTo: firstAudioButton.bottomAnchor, constant: K.padding),
            //FadeValue
            fadeValueLabel.topAnchor.constraint(equalTo: fadeSlider.bottomAnchor),
            fadeValueLabel.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor),
            //PlayButton
            playButton.topAnchor.constraint(equalTo: fadeValueLabel.bottomAnchor, constant: K.padding),
            playButton.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor)
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
    private func addActions() {
        
        firstAudioButton.addAction(UIAction(handler: {[unowned self] _ in
            if playButton.currentState == .play {
                print("Stop player first")
            } else {
                self.delegate?.soundButtonPressed(sender: self.firstAudioButton)
            }
        }), for: .touchUpInside)
        secondAudioButton.addAction(UIAction(handler: {[unowned self] _ in
            if playButton.currentState == .play {
                print("Stop player first")
            } else {
                self.delegate?.soundButtonPressed(sender: self.secondAudioButton)
            }
        }), for: .touchUpInside)
        
        fadeSlider.addAction(UIAction(handler: {[unowned self] _ in
            self.fadeSlider.setValue(roundf(self.fadeSlider.value), animated: true)
        }), for: .touchUpInside)
        fadeSlider.addAction(UIAction(handler: {[unowned self] _ in
            self.fadeValueLabel.text = String(format: "%.f", self.sliderValue)
        }), for: .valueChanged)
        
        playButton.addAction(UIAction(handler: {[unowned self] _ in
            self.delegate?.playButtonPressed()
        }), for: .touchUpInside)
    }
    
    func toggleButtonsState(_ value: Bool) {
        if value {
            playButton.setTitle(K.Button.stop, for: .normal)
            playButton.currentState = .play
        } else {
            playButton.setTitle(K.Button.play, for: .normal)
            playButton.currentState = .stop
        }
        fadeSlider.isEnabled = !value
    }
    
    func updateButton(_ button: PlayerButton) {
        button.currentState = .filled
    }
    
}

extension UIView {
    @discardableResult func prepareForAutoLayout() -> Self {
        self.translatesAutoresizingMaskIntoConstraints = false
        return self
    }
}
