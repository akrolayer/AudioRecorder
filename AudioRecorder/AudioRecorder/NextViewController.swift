//
//  NextViewController.swift
//  AudioRecorder
//
//  Created by akrolayer on 2020/11/18.
//  Copyright © 2020 akrolayer. All rights reserved.
//

import UIKit
import AVFoundation

class NextViewController: UIViewController {
    
    var FileName:String = ""
    
    var audioRecorder: AVAudioRecorder!
    var audioEngine: AVAudioEngine!
    var audioFile: AVAudioFile!
    var audioPlayerNode: AVAudioPlayerNode!
    
    @IBOutlet var playButton: UIButton!
    @IBOutlet var Label: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        Label.text = FileName
    }
    
    
    @IBAction func TapPlayButton(_ sender: Any) {
        play()
    }
    
    func play(){
        audioEngine = AVAudioEngine()
        do {
            audioFile = try AVAudioFile(forReading: getAudioFileUrl(FileName: FileName))

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
    
    func getAudioFileUrl(FileName:String) -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let docsDirect = paths[0]
        
        let audioUrl = docsDirect.appendingPathComponent(FileName)

        return audioUrl
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
