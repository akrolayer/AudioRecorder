//
//  ViewController.swift
//  AudioRecorder
//
//  Created by akrolayer on 2020/08/27.
//  Copyright © 2020 akrolayer. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    var audioRecorder: AVAudioRecorder!
    var audioEngine: AVAudioEngine!
    var audioFile: AVAudioFile!
    var audioPlayerNode: AVAudioPlayerNode!
    
 override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        let session = AVAudioSession.sharedInstance()
        session.requestRecordPermission { granted in
            if granted{
                do {
                    try session.setCategory(.playAndRecord, mode: .default)
                    try session.setActive(true)

                    let settings = [
                        AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
                        AVSampleRateKey: 44100,
                        AVNumberOfChannelsKey: 2,
                        AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
                    ]

                    self.audioRecorder = try AVAudioRecorder(url: self.getAudioFileUrl(), settings: settings)
                    self.audioRecorder.delegate = self as? AVAudioRecorderDelegate
                } catch let error {
                    print(error)
                }
            }
            else{
                //アラートのタイトル
                let dialog = UIAlertController(title: "許可がないと機能を使えません。ホームボタンを押してください。", message: "", preferredStyle: .alert)
                //ボタンのタイトル
                dialog.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                //実際に表示させる
                self.present(dialog, animated: true, completion: nil)
            }
        }
        
    }
    
    @IBAction func record(_ sender: Any) {
        if !audioRecorder.isRecording {
            audioRecorder.record()
        } else {
            audioRecorder.stop()
        }
    }

    @IBAction func play(_ sender: Any) {
        audioEngine = AVAudioEngine()
        do {
            audioFile = try AVAudioFile(forReading: getAudioFileUrl())

            audioPlayerNode = AVAudioPlayerNode()
            audioEngine.attach(audioPlayerNode)
            audioEngine.connect(audioPlayerNode, to: audioEngine.outputNode, format: audioFile.processingFormat)

            audioPlayerNode.stop()
            audioPlayerNode.scheduleFile(audioFile, at: nil)

            try audioEngine.start()
            audioPlayerNode.play()
        } catch let error {
            print(error)
        }
    }

    func getAudioFileUrl() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let docsDirect = paths[0]
        let audioUrl = docsDirect.appendingPathComponent("recording.m4a")

        return audioUrl
    }


}

