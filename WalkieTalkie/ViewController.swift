//
//  ViewController.swift
//  WalkieTalkie
//
//  Created by Kittiphong Xayasane on 2019-10-16.
//  Copyright © 2019 Kittiphong Xayasane. All rights reserved.
//

import UIKit
import AVFoundation


class ViewController: UIViewController, AVAudioRecorderDelegate, UITableViewDelegate, UITableViewDataSource, AVAudioPlayerDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recordings.count
    }

    lazy var audioRecorder: AVAudioRecorder? = {
        return initAudioRecorder()
    }()

    lazy var audioSession: AVAudioSession? = {
        return initAudioSession()
    }()

    lazy var audioPlayer: AVAudioPlayer? = {
        return initAudioPlayer(withFileURL: nil)
    }()

    var isRecording = false
    var recordings: [AudioRecording] = []
    @IBOutlet weak var recordingsTableView: UITableView!
    @IBOutlet weak var recordButton: UIButton!
    @IBAction func recordButtonTapped(_ sender: Any) {
        if (!isRecording) {
            do {
                try audioSession?.setActive(true, options: [])
                audioRecorder = initAudioRecorder()
                recordAudio(withAudioRecorder: audioRecorder)
                isRecording = true
            } catch {
                isRecording = false;
            }
        } else {
            audioRecorder?.stop()
            isRecording = false
            recordingsTableView.reloadData()
        }

        recordButton.setTitle(isRecording ? "Recording" : "Press to Record", for: .normal)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        recordButton.setTitle(isRecording ? "Recording" : "Press to Record", for: .normal)
        recordingsTableView.delegate = self
        recordingsTableView.dataSource = self
    }

    // MARK: Initialization

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
        let settings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 12000,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]
        
        do {
            let audioRecorder = try AVAudioRecorder(url: audioFilename, settings: settings)
            audioRecorder.delegate = self
            return audioRecorder
        } catch {
        }
        return nil
    }
    
    func initAudioPlayer(withFileURL fileURL: URL?) -> AVAudioPlayer? {
        guard let fileURL = fileURL else {
            return nil
        }
        var error: NSError?
        do {
            let audioPlayer = try AVAudioPlayer(contentsOf: fileURL as URL)
            audioPlayer.delegate = self
            audioPlayer.prepareToPlay()
            audioPlayer.volume = 10.0
            return audioPlayer
        } catch let error1 as NSError {
            error = error1
            audioPlayer = nil
        }

        if let err = error {
            print("AVAudioPlayer error: \(err.localizedDescription)")
        }

        return nil
    }

    // MARK: Recording Methods

    func recordAudio(withAudioRecorder audioRecorder: AVAudioRecorder?) {
        audioRecorder?.record()
        recordings.append(AudioRecording(audioRecorder?.url.absoluteString, filePath: audioRecorder?.url))
    }

    // MARK: General Helper Methods

    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    func getFileURL() -> URL {
        let path = getDocumentsDirectory().appendingPathComponent(getTodayString() + ".m4a")
        return path as URL
    }

    func getTodayString() -> String{
        let date = Date()
        let calender = Calendar.current
        let components = calender.dateComponents([.year,.month,.day,.hour,.minute,.second], from: date)
        let year = components.year
        let month = components.month
        let day = components.day
        let hour = components.hour
        let minute = components.minute
        let second = components.second
        let today_string = String(year!) + "-" + String(month!) + "-" + String(day!) + " " + String(hour!)  + ":" + String(minute!) + ":" +  String(second!)

        return today_string
    }

    // MARK: TableView Delegate Methods
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "cellReuseIdentifier") as? UITableViewCell ?? UITableViewCell()

        // set the text from the data model
        if let recording = self.recordings[indexPath.row] as? AudioRecording  {
            cell.textLabel?.text = recording.title
        }

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let recording = self.recordings[indexPath.row] as? AudioRecording,
            let filePath = (recordings[indexPath.row] as? AudioRecording)?.filePath
            /*let audioPlayer = try AVAudioPlayer(contentsOf: filePath) initAudioPlayer(withFileURL: filePath) */ {
            do {
                audioPlayer = try AVAudioPlayer(contentsOf: filePath)
                audioPlayer?.prepareToPlay()
                audioPlayer?.play()
            } catch {
            }
        }
    }
}

