//
//  PlaySoundsViewController.swift
//  Pitch Perfect 2
//
//  Created by Kenji Golimlim on 5/9/15.
//  Copyright (c) 2015 Kenji Golimlim. All rights reserved.
//

import UIKit
import AVFoundation

class PlaySoundsViewController: UIViewController {
  
  // Below: Declarations, setup

  var audioPlayer:AVAudioPlayer!
  var receivedAudio:RecordedAudio!
  var audioEngine:AVAudioEngine!
  var audioFile:AVAudioFile!
  
  override func viewDidLoad() {
    super.viewDidLoad()    
    audioPlayer = AVAudioPlayer(contentsOfURL: receivedAudio.filePathUrl, error: nil)
    audioPlayer.enableRate = true
    
    audioEngine = AVAudioEngine()
    audioFile = AVAudioFile(forReading: receivedAudio.filePathUrl, error: nil)
    
      // Do any additional setup after loading the view.
  }
  
  // Below: Functions that change speed
  
  @IBAction func SlowAudio(sender: UIButton) {
    playAudioWithVariableSpeed(0.5)
  }
  
  @IBAction func FastAudio(sender: UIButton) {
    playAudioWithVariableSpeed(2.0)
  }
  
  func playAudioWithVariableSpeed(speed: Float){
    stopAllAudio()
    audioPlayer.rate = speed
    audioPlayer.currentTime = 0.0
    audioPlayer.play()
  }
  
  // Below: Functions that change pitch
  
  @IBAction func ChipmunkAudio(sender: UIButton) {
    playAudioWithVariablePitch(1000)
  }
  
  @IBAction func VaderAudio(sender: UIButton) {
    playAudioWithVariablePitch(-1000)
  }
  
  func playAudioWithVariablePitch(pitch: Float){
    stopAllAudio()
    
    var audioPlayerNode = AVAudioPlayerNode()
    audioEngine.attachNode(audioPlayerNode)
    
    var changePitchEffect = AVAudioUnitTimePitch()
    changePitchEffect.pitch = pitch
    audioEngine.attachNode(changePitchEffect)
    
    audioEngine.connect(audioPlayerNode, to: changePitchEffect, format: nil)
    audioEngine.connect(changePitchEffect, to: audioEngine.outputNode, format: nil)
    
    audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
    audioEngine.startAndReturnError(nil)
    
    audioPlayerNode.play()
  }
  
  // Below: Other functions
  
  @IBAction func StopAudio(sender: UIButton) {
    audioPlayer.currentTime = 0.0
    stopAllAudio()
  }
  
  func stopAllAudio(){
    audioPlayer.stop()
    audioEngine.stop()
    audioEngine.reset()
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
}
