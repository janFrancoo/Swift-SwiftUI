//
//  ViewController.swift
//  RecordAudioExample
//
//  Created by JanFranco on 28.09.2020.
//  Copyright © 2020 janfranco. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController, AVAudioRecorderDelegate, AVAudioPlayerDelegate {
    
    private var audioRecorder: AVAudioRecorder!
    private var audioPlayer: AVAudioPlayer!
    private var isRecording = false
    private var isPlaying = false
    private var isAudioRecordingGranted: Bool!
    
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var playButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    private func setup() {
        checkPermission()
        playButton.isEnabled = false
        recordButton.addTarget(self, action: #selector(record(_:)), for: .touchUpInside)
        playButton.addTarget(self, action: #selector(playRecord(_:)), for: .touchUpInside)
    }
    
    @objc func record(_ sender: UIButton) {
        if isRecording {
            finishRecord(success: true)
            recordButton.setTitle("Record", for: .normal)
            playButton.isEnabled = true
            isRecording = false
        } else {
            setupRecorder()
            audioRecorder.record()
            recordButton.setTitle("Stop", for: .normal)
            playButton.isEnabled = false
            isRecording = true
        }
    }
    
    @objc func playRecord(_ sender: UIButton) {
        if isPlaying {
            audioPlayer.stop()
            recordButton.isEnabled = true
            playButton.setTitle("Play", for: .normal)
            isPlaying = false
        } else {
            if FileManager.default.fileExists(atPath: getFileUrl().path) {
                recordButton.isEnabled = false
                playButton.setTitle("Pause", for: .normal)
                preparePlay()
                audioPlayer.play()
                isPlaying = true
            } else {
                makeAlert(title: "Error", message: "File not found")
            }
        }
    }
    
    private func checkPermission() {
        switch AVAudioSession.sharedInstance().recordPermission {
            case AVAudioSessionRecordPermission.granted:
                isAudioRecordingGranted = true
                break
            case AVAudioSessionRecordPermission.denied:
                isAudioRecordingGranted = false
                break
            case AVAudioSessionRecordPermission.undetermined:
                AVAudioSession.sharedInstance().requestRecordPermission({ (allowed) in
                        if allowed {
                            self.isAudioRecordingGranted = true
                        } else {
                            self.isAudioRecordingGranted = false
                        }
                })
                break
            default:
                break
        }
    }
    
    private func setupRecorder() {
        if isAudioRecordingGranted {
            let session = AVAudioSession.sharedInstance()
            
            do {
                try session.setCategory(AVAudioSession.Category.playAndRecord, options: .defaultToSpeaker)
                try session.setActive(true)
                
                let settings = [
                    AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
                    AVSampleRateKey: 44100,
                    AVNumberOfChannelsKey: 2,
                    AVEncoderAudioQualityKey:AVAudioQuality.high.rawValue
                ]
                
                audioRecorder = try AVAudioRecorder(url: getFileUrl(), settings: settings)
                audioRecorder.delegate = self
                audioRecorder.prepareToRecord()
            } catch let error {
                print(error.localizedDescription)
            }
        } else {
            makeAlert(title: "Error", message: "No permission granted")
        }
    }
    
    private func finishRecord(success: Bool) {
        if success {
            audioRecorder.stop()
            audioRecorder = nil
            makeAlert(title: "Success", message: "Recorded successfully")
        } else {
            makeAlert(title: "Error", message: "Recording failed")
        }
    }
    
    private func preparePlay() {
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: getFileUrl())
            audioPlayer.delegate = self
            audioPlayer.prepareToPlay()
        } catch let error {
            print(error.localizedDescription)
        }
    }

    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if !flag {
            finishRecord(success: false)
        }
        playButton.isEnabled = true
    }

    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        recordButton.isEnabled = true
    }
    
    private func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }

    private func getFileUrl() -> URL {
        let filename = "janfranco_test.m4a"
        let filePath = getDocumentsDirectory().appendingPathComponent(filename)
        return filePath
    }
    
    private func makeAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default)
        alert.addAction(okButton)
        self.present(alert, animated: true, completion: nil)
    }

}
