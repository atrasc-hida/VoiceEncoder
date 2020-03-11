//
//  ViewController.swift
//  RecordingSample
//
//  Created by 飛田 由加 on 2020/03/10.
//  Copyright © 2020 atrasc. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController, AVAudioPlayerDelegate, VoiceEncoderDelegate {
   
    @IBOutlet weak var recordButton: CustomButton!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var playButton: CustomButton!
    
    var audioPlayer: AVAudioPlayer!
    var isPlaying = false
    var isRecording = false
    var encodedString = ""
    
    var encoder: VoiceEncoder?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        playButton.disableButton()
        
        encoder = VoiceEncoder()
        encoder!.delegate = self
    }
    
    @IBAction func play(_ sender: UIButton) {
        if !isPlaying {
           
            if let decodedData:Data = Data(base64Encoded: encodedString) {
                audioPlayer = try! AVAudioPlayer(data: decodedData)
                audioPlayer.delegate = self
                audioPlayer.play()

                isPlaying = true

                label.text = "再生中"
                playButton.setTitle("停止", for: .normal)
                recordButton.disableButton()
            } else {
                print("デコード失敗")
            }

        } else {
            audioPlayer.stop()
            isPlaying = false

            label.text = "待機中"
            playButton.setTitle("再生", for: .normal)
            recordButton.enableButton()
        }
    }
    
    @IBAction func record(_ sender: UIButton) {
        if !isRecording {
            //録音開始
            encoder!.start()
            
            label.text = "録音中"
            recordButton.setTitle("録音停止", for: .normal)
            playButton.disableButton()
            isRecording = true
        } else {
            //録音停止
            encoder!.stop()
            
            label.text = "待機中"
            recordButton.setTitle("録音開始", for: .normal)
            playButton.enableButton()
            isRecording = false
        }
    }
    
    //MARK: - VoiceEncoderDelegate
    func voiceEncoder(_: VoiceEncoder, didEncodedTo string: String) {
        encodedString = string
    }
}
