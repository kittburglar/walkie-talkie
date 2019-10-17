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

    lazy var audioRecorder: AVAudioRecorder? = {
        return initAudioRecorder()
    }()

    lazy var audioSession: AVAudioSession? = {
        return initAudioSession()
    }()

    var isRecording = false

    @IBOutlet weak var recordButton: UIButton!
    @IBAction func recordButtonTapped(_ sender: Any) {
        if (!isRecording) {
            do {
                try audioSession?.setActive(true, options: [])
                audioRecorder?.record()
                isRecording = true
            } catch {
                isRecording = false;
            }
        } else {
            audioRecorder?.stop()
        }

        recordButton.setTitle(isRecording ? "Recording" : "Press to Record", for: .normal)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
    }

    func initAudioSession() -> AVAudioSession? {
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(.playAndRecord)
            
            audioSession.requestRecordPermission { (approved) in
                if (approved) {
                    print("you can record.")
                } else {
                    print("you can't record.")
                }
            }
            return audioSession
        } catch {
            print("Setting category to AVAudioSessionCategoryPlayAndRecord failed.")
        }
        return nil
    }
    
    func initAudioRecorder() -> AVAudioRecorder? {
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
            return audioRecorder
        } catch {
        }
        return nil
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

