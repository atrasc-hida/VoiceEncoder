//
//  VoiceEncoder.swift
//  RecordingSample
//
//  Created by 飛田 由加 on 2020/03/11.
//  Copyright © 2020 atrasc. All rights reserved.
//

import Foundation
import AVFoundation

class VoiceEncoder: NSObject, AVAudioRecorderDelegate {
    
    var delegate: VoiceEncoderDelegate?
    
    private var audioRecorder: AVAudioRecorder!
    private var isRecording = false
    
    func start() {
        if isRecording { return }
        //録音開始
        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSession.Category.playAndRecord)
        try! session.setActive(true)

        let settings = [
            AVSampleRateKey: 16000, //サンプリングレート：16,000Hz
            AVEncoderBitRateKey:16, //量子化ビットレート
            AVNumberOfChannelsKey: 1, //CH数：１
            AVLinearPCMIsBigEndianKey:0, //エンディアン：Little-Endian
            AVFormatIDKey:Int(kAudioFormatLinearPCM), //エンコード：リニアPCM
            AVAudioFileTypeKey:Int(kAudioFileWAVEType) //wav形式
        ]

        audioRecorder = try! AVAudioRecorder(url: getURL(), settings: settings)
        audioRecorder.delegate = self
        audioRecorder.record()

        isRecording = true
    }
    
    func stop() {
        if !isRecording { return }
        //録音停止
        audioRecorder.stop()
        isRecording = false

        //Base64でエンコード
        var encodedString:String = ""
        if let data: Data = getFileData(getURL().path) {
            encodedString = data.base64EncodedString()
        } else {
            print("エンコード失敗")
        }
        delegate?.voiceEncoder(self, didEncodedTo: encodedString)
    }
    
    private func getURL() -> URL{
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let docsDirect = paths[0]
        let url = docsDirect.appendingPathComponent("recording.wav")
        return url
    }
    
    private func getFileData(_ filePath: String) -> Data? {
        let fileData: Data?
        do {
            fileData = try Data(contentsOf: URL(fileURLWithPath: filePath))
        } catch {
            fileData = nil
        }
        return fileData
    }
}

protocol VoiceEncoderDelegate {
    func voiceEncoder(_:VoiceEncoder, didEncodedTo string:String)
}
