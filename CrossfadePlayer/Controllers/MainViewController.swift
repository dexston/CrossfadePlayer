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
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(forName: UIApplication.willResignActiveNotification, object: nil, queue: .main) {[weak self] _ in
            guard let self = self else { return }
            self.playerManager.pause()
        }
        notificationCenter.addObserver(forName: UIApplication.willEnterForegroundNotification, object: nil, queue: .main) {[weak self] _ in
            guard let self = self else { return }
            if self.playerManager.isPaused {
                self.playerManager.resumeWith(fadeDuration: self.mainView.fadeSliderValue)
            }
        }
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
        if let soundButton = soundButton {
            playerManager.addSound(from: url)
            let soundName = url.lastPathComponent
            mainView.updateSoundButton(soundButton, with: soundName)
        }
    }
    
    private func showAlert(with error: K.Error) {
        let alert = UIAlertController(title: nil, message: error.rawValue, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
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
            playerManager.playWith(fadeDuration: mainView.fadeSliderValue)
        } else {
            playerManager.stop()
        }
    }
    
    func pauseButtonPressed() {
        if !playerManager.isPlaying {
            playerManager.resumeWith(fadeDuration: mainView.fadeSliderValue)
        } else {
            playerManager.pause()
        }
    }
}

extension MainViewController: PlayerManagerDelegate {
    
    func playerStateChanged(_ value: Bool) {
        mainView.toggleButtonsState(value)
    }
    
    func errorThrown(_ error: K.Error) {
        showAlert(with: error)
    }
}

extension MainViewController: UIDocumentPickerDelegate {
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        guard let selectedFileURL = urls.first else { return }

        addSoundUrl(selectedFileURL)

    }
}
