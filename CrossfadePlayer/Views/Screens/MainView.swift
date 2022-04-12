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
    
    private let verticalStack: UIStackView = {
        let stack = UIStackView()
        stack.prepareForAutoLayout()
        stack.axis = .vertical
        stack.alignment = .center
        stack.distribution = .fill
        stack.spacing = K.padding
        return stack
    }()

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
        slider.minimumValue = K.FadeSlider.minValue
        slider.maximumValue = K.FadeSlider.maxValue
        slider.value = K.FadeSlider.initialValue
        return slider
    }()
    
    private let fadeValueLabel: UILabel = {
        let label = UILabel()
        label.prepareForAutoLayout()
        label.font = .preferredFont(forTextStyle: .subheadline)
        return label
    }()
    
    private let playButton: PlayerButton = {
        let button = PlayerButton()
        button.currentState = .stopped
        button.setImage(K.Button.play, for: .normal)
        return button
    }()
    
    private let emptyView: UIView = {
        let view = UIView()
        view.prepareForAutoLayout()
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupMainView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupMainView()
    }

    private func setupMainView() {
        backgroundColor = .systemBackground
        addSubview(verticalStack)
        fadeValueLabel.text = String(format: K.currentFadeValue, fadeSlider.value)
        setupStackView()
        setupConstraints()
        setupActions()
    }
    
    private func setupStackView() {
        verticalStack.addArrangedSubview(titleLabel)
        verticalStack.addArrangedSubview(firstAudioButton)
        verticalStack.addArrangedSubview(secondAudioButton)
        verticalStack.addArrangedSubview(fadeValueLabel)
        verticalStack.addArrangedSubview(fadeSlider)
        verticalStack.addArrangedSubview(playButton)
        verticalStack.addArrangedSubview(emptyView)
        verticalStack.setCustomSpacing(2.0, after: fadeValueLabel)
    }
    
    private func setupConstraints() {
        let constraints = [
            //VerticalStack
            verticalStack.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: K.padding),
            verticalStack.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: K.padding),
            verticalStack.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -K.padding),
            verticalStack.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -K.padding),
            //TitleLabel
            titleLabel.heightAnchor.constraint(equalTo: safeAreaLayoutGuide.heightAnchor, multiplier: 0.2),
            //FirstButton
            firstAudioButton.leadingAnchor.constraint(equalTo: verticalStack.leadingAnchor),
            firstAudioButton.trailingAnchor.constraint(equalTo: verticalStack.trailingAnchor),
            firstAudioButton.heightAnchor.constraint(equalTo: safeAreaLayoutGuide.heightAnchor, multiplier: 0.1),
            //SecondButton
            secondAudioButton.leadingAnchor.constraint(equalTo: firstAudioButton.leadingAnchor),
            secondAudioButton.trailingAnchor.constraint(equalTo: firstAudioButton.trailingAnchor),
            secondAudioButton.heightAnchor.constraint(equalTo: firstAudioButton.heightAnchor),
            //FadeSlider
            fadeSlider.leadingAnchor.constraint(equalTo: secondAudioButton.leadingAnchor),
            fadeSlider.trailingAnchor.constraint(equalTo: secondAudioButton.trailingAnchor),
            //PlayButton
            playButton.heightAnchor.constraint(equalTo: firstAudioButton.heightAnchor),
            playButton.widthAnchor.constraint(equalTo: playButton.heightAnchor)
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
    private func setupActions() {
        
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
            self.fadeValueLabel.text = String(format: K.currentFadeValue, self.fadeSlider.value)
        }), for: .valueChanged)
        
        playButton.addAction(UIAction(handler: {[unowned self] _ in
            self.delegate?.playButtonPressed()
        }), for: .touchUpInside)
    }
    
    func toggleButtonsState(_ value: Bool) {
        if value {
            playButton.setImage(K.Button.stop, for: .normal)
            playButton.currentState = .playing
        } else {
            playButton.setImage(K.Button.play, for: .normal)
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
