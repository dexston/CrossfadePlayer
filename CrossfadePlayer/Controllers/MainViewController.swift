//
//  MainViewController.swift
//  CrossfadePlayer
//
//  Created by Admin on 05.04.2022.
//

import UIKit

class MainViewController: UIViewController {

    private let mainView = MainView()
    private var playerManager = PlayerManager()
    
    private var soundButton: PlayerButton?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }

    private func setupView() {
        view.addSubview(mainView.prepareForAutoLayout())
        let constraints = [
            mainView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mainView.topAnchor.constraint(equalTo: view.topAnchor),
            mainView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            mainView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ]
        NSLayoutConstraint.activate(constraints)
        mainView.delegate = self
        playerManager.delegate = self
    }
    
    private func addSoundUrl(_ url: URL) {
        if soundButton == mainView.firstAudioButton {
            playerManager.addFirstSound(from: url)
            mainView.updateButton(mainView.firstAudioButton)
        } else if soundButton == mainView.secondAudioButton {
            playerManager.addSecondSound(from: url)
            mainView.updateButton(mainView.secondAudioButton)
        }
    }
    
}

extension MainViewController: MainViewDelegate {
    
    func soundButtonPressed(sender: PlayerButton) {
        let documentPicker = UIDocumentPickerViewController(forOpeningContentTypes: [.audio])
        documentPicker.delegate = self
        documentPicker.allowsMultipleSelection = false
        present(documentPicker, animated: true) {
            self.soundButton = sender
        }
    }
    
    func playButtonPressed() {
        if !playerManager.isPlaying {
            playerManager.fadeDuration = Double(mainView.sliderValue)
            playerManager.prepareAndPlay()
        } else {
            playerManager.stop()
        }
    }
}

extension MainViewController: PlayerManagerDelegate {
    
    func toggleButtons(_ value: Bool) {
        mainView.toggleButtonsState(value)
    }
}

extension MainViewController: UIDocumentPickerDelegate {
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        guard let selectedFileURL = urls.first else { return }

        addSoundUrl(selectedFileURL)

    }
}
