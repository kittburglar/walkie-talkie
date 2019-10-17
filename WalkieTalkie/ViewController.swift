//
//  ViewController.swift
//  WalkieTalkie
//
//  Created by Kittiphong Xayasane on 2019-10-16.
//  Copyright © 2019 Kittiphong Xayasane. All rights reserved.
//

import UIKit
import AVFoundation


class ViewController: UIViewController, AVAudioRecorderDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        setupAudioSession()
        setupAudioFilePath()
    }

    func setupAudioSession() {
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(.playAndRecord)
            try audioSession.setActive(true, options: [])
            
            audioSession.requestRecordPermission { (approved) in
                if (approved) {
                    print("you can record.")
                } else {
                    print("you can't record.")
                }
            }
            
            
        } catch {
            print("Setting category to AVAudioSessionCategoryPlayAndRecord failed.")
        }
    }
    
    func setupAudioFilePath() {
        let audioFilename = getFileURL()
        print("\(audioFilename)")
        let settings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 12000,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]
        
        do {
            let audioRecorder = try AVAudioRecorder(url: audioFilename, settings: settings)
            audioRecorder.delegate = self
            audioRecorder.record()
        } catch {
        }
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    func getFileURL() -> URL {
        let path = getDocumentsDirectory().appendingPathComponent("recording.m4a")
        return path as URL
    }
}

