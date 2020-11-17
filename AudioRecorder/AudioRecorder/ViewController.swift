//
//  ViewController.swift
//  AudioRecorder
//
//  Created by akrolayer on 2020/08/27.
//  Copyright © 2020 akrolayer. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController,AVAudioRecorderDelegate,UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return textArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell",for:indexPath)
        
        cell.textLabel?.text = textArray[indexPath.row]
        cell.selectionStyle = .none
        return cell
    }
    var textArray = [String]()
    var audioRecorder: AVAudioRecorder!
    var audioEngine: AVAudioEngine!
    var audioFile: AVAudioFile!
    var audioPlayerNode: AVAudioPlayerNode!
    
    var FileNameIndex:Int = 1
    var FilePathArray:[URL] = []
    
    @IBOutlet var recordButton: UIButton!
    @IBOutlet var tableview: UITableView!
    
 override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    tableview.delegate = self
    tableview.dataSource = self
    
        let session = AVAudioSession.sharedInstance()
        session.requestRecordPermission { granted in
            if granted{
                self.recordButton.isEnabled = true
            }
            else{
                //アラートのタイトル
                let dialog = UIAlertController(title: "許可がないと機能を使えません。ホームボタンを押してください。", message: "", preferredStyle: .alert)
                //ボタンのタイトル
                dialog.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                //実際に表示させる
                self.present(dialog, animated: true, completion: nil)
                self.recordButton.isEnabled = false
            }
        }
        
    }
    
    @IBAction func record(_ sender: Any) {
        if audioRecorder == nil || !audioRecorder.isRecording {
            let image = UIImage(systemName: "stop.circle")
            recordButton.setImage(image, for: UIControl.State.normal)
            recordButton.imageView?.contentMode = .scaleAspectFit
        
            let session = AVAudioSession.sharedInstance()
            do{
                try session.setCategory(.playAndRecord, mode: .default)
                try session.setActive(true)
                let settings = [
                AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
                AVSampleRateKey: 44100,
                AVNumberOfChannelsKey: 2,
                AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
                ]
            
                self.audioRecorder = try AVAudioRecorder(url: self.getAudioFileUrl( "record.m4a"), settings: settings)
                audioRecorder.record()
            }catch{
                print(error)
            }
        }
         else {
            audioRecorder.stop()
            let image2 = UIImage(systemName: "mic.circle")
            recordButton.setImage(image2, for: UIControl.State.normal)
            recordButton.imageView?.contentMode = .scaleAspectFit
            Dialog()
        }
    }
    
    func getAudioFileUrl(_ FileName:String) -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let docsDirect = paths[0]
        
        let audioUrl = docsDirect.appendingPathComponent(FileName)

        return audioUrl
    }
    func Dialog(){
        let Dialog = UIAlertController(title: "保存するファイル名を入力してください", message: "", preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default, handler: {[Dialog](action) -> Void in
            guard let textFields = Dialog.textFields else{
                return
            }
            guard !textFields.isEmpty else{
                return
            }

            let FileName = textFields[0].text!
            self.textArray.append(FileName)
            self.tableview.reloadData()
        })
        let cancel = UIAlertAction(title: "キャンセル", style: .cancel, handler: nil)
        let image = UIImage(systemName: "mic.circle")
        recordButton.setImage(image, for: UIControl.State.normal)
        recordButton.imageView?.contentMode = .scaleAspectFit
        Dialog.addTextField(configurationHandler: nil)
        
        Dialog.addAction(ok)
        Dialog.addAction(cancel)
        present(Dialog, animated: true,completion: nil)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return view.frame.size.height/6
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let nextVC = storyboard?.instantiateViewController(withIdentifier: "next") as! NextViewController
        
        nextVC.FileName = textArray[indexPath.row]
        navigationController?.pushViewController(nextVC, animated: true)
    }
}

