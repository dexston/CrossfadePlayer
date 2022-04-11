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
    func errorThrown(_ error: K.Error)
}

class MainView: UIView {
    
    weak var delegate: MainViewDelegate?
    
    var fadeSliderValue: Double {
        Double(fadeSlider.value)
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
        button.setTitle(K.Button.firstSound, for: .normal)
        return button
    }()
    
    let secondAudioButton: PlayerButton = {
        let button = PlayerButton()
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
        button.currentState = .stopped
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
        fadeValueLabel.text = String(format: "%.f", fadeSlider.value)
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
            firstAudioButton.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -K.padding),
            firstAudioButton.heightAnchor.constraint(equalTo: safeArea.heightAnchor, multiplier: 0.1),
            //SecondButton
            secondAudioButton.leadingAnchor.constraint(equalTo: firstAudioButton.leadingAnchor),
            secondAudioButton.topAnchor.constraint(equalTo: firstAudioButton.bottomAnchor, constant: K.padding),
            secondAudioButton.trailingAnchor.constraint(equalTo: firstAudioButton.trailingAnchor),
            secondAudioButton.heightAnchor.constraint(equalTo: firstAudioButton.heightAnchor),
            //FadeSlider
            fadeSlider.leadingAnchor.constraint(equalTo: secondAudioButton.leadingAnchor),
            fadeSlider.trailingAnchor.constraint(equalTo: secondAudioButton.trailingAnchor),
            fadeSlider.topAnchor.constraint(equalTo: secondAudioButton.bottomAnchor, constant: K.padding),
            //FadeValue
            fadeValueLabel.topAnchor.constraint(equalTo: fadeSlider.bottomAnchor),
            fadeValueLabel.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor),
            //PlayButton
            playButton.topAnchor.constraint(equalTo: fadeValueLabel.bottomAnchor, constant: K.padding),
            playButton.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor),
            playButton.heightAnchor.constraint(equalTo: safeArea.heightAnchor, multiplier: 0.1),
            playButton.widthAnchor.constraint(equalTo: playButton.heightAnchor)
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
    private func addActions() {
        
        firstAudioButton.addAction(UIAction(handler: {[unowned self] _ in
            if playButton.currentState == .playing {
                self.delegate?.errorThrown(.stopPlayerFirst)
            } else {
                self.delegate?.soundButtonPressed(sender: self.firstAudioButton)
            }
        }), for: .touchUpInside)
        secondAudioButton.addAction(UIAction(handler: {[unowned self] _ in
            if playButton.currentState == .playing {
                self.delegate?.errorThrown(.stopPlayerFirst)
            } else {
                self.delegate?.soundButtonPressed(sender: self.secondAudioButton)
            }
        }), for: .touchUpInside)
        
        fadeSlider.addAction(UIAction(handler: {[unowned self] _ in
            self.fadeSlider.setValue(roundf(self.fadeSlider.value), animated: true)
        }), for: .touchUpInside)
        fadeSlider.addAction(UIAction(handler: {[unowned self] _ in
            self.fadeValueLabel.text = String(format: "%.f", self.fadeSlider.value)
        }), for: .valueChanged)
        
        playButton.addAction(UIAction(handler: {[unowned self] _ in
            self.delegate?.playButtonPressed()
        }), for: .touchUpInside)
    }
    
    func toggleButtonsState(_ value: Bool) {
        if value {
            playButton.setTitle(K.Button.stop, for: .normal)
            playButton.currentState = .playing
        } else {
            playButton.setTitle(K.Button.play, for: .normal)
            playButton.currentState = .stopped
        }
        fadeSlider.isEnabled = !value
    }
    
    func updateSoundButton(_ button: PlayerButton, with name: String) {
        button.currentState = .filled
        button.setTitle(name, for: .normal)
    }    
}

extension UIView {
    @discardableResult func prepareForAutoLayout() -> Self {
        self.translatesAutoresizingMaskIntoConstraints = false
        return self
    }
}
