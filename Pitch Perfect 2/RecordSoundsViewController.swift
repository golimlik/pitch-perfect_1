//
//  RecordSoundsViewController.swift
//  Pitch Perfect 2
//
//  Created by Kenji Golimlim on 5/9/15.
//  Copyright (c) 2015 Kenji Golimlim. All rights reserved.
//

//  Note: This project bundle is called Pitch Perfect 2 because
//  the original Pitch Perfect project used the wrong dimensions
//  in the storyboard, and only the microphone button transferred
//  between different dimensions. I could not figure out how to
//  replicate that with the rest of the buttons without causing
//  errors and having to redo the code.

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {
  
  // Below: Declarations

  @IBOutlet weak var RecordButton: UIButton!
  @IBOutlet weak var RecordingInProgress: UILabel!
  @IBOutlet weak var StopButton: UIButton!
  @IBOutlet weak var TapToRecord: UILabel!
  
  var audioRecorder:AVAudioRecorder!
  var recordedAudio:RecordedAudio!
  
  // Below: Functions
  
  override func viewWillAppear(animated: Bool) {
    RecordButton.enabled = true
    StopButton.hidden = true
    TapToRecord.hidden = false
    // Dictates what appears when the app starts
  }

  @IBAction func recordAudio(sender: UIButton) {
    RecordButton.enabled = false
    RecordingInProgress.hidden = false
    StopButton.hidden = false
    TapToRecord.hidden = true
    
    // Below: Preparation for recording process
    
    let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as! String
    
    let currentDateTime = NSDate()
    let formatter = NSDateFormatter()
    formatter.dateFormat = "ddMMyyyy-HHmmss"
    let recordingName = formatter.stringFromDate(currentDateTime)+".wav"
    let pathArray = [dirPath, recordingName]
    let filePath = NSURL.fileURLWithPathComponents(pathArray)
    println(filePath)
    
    var session = AVAudioSession.sharedInstance()
    session.setCategory(AVAudioSessionCategoryPlayAndRecord, error: nil)
    audioRecorder = AVAudioRecorder(URL: filePath, settings: nil, error: nil)
    audioRecorder.delegate = self
    audioRecorder.meteringEnabled = true
    audioRecorder.prepareToRecord()
    audioRecorder.record()
    
  }
    
  func audioRecorderDidFinishRecording(recorder: AVAudioRecorder!, successfully flag: Bool) {
    if(flag){
      recordedAudio = RecordedAudio(filePathUrl: recorder.url, title: recorder.url.lastPathComponent)
    
      self.performSegueWithIdentifier("stopRecording", sender: recordedAudio)
    }
    else{
      println("Recording was not successful")
      RecordButton.enabled = true
      StopButton.hidden = true
    }
  }
  
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if (segue.identifier == "stopRecording"){
      let playSoundsVC:PlaySoundsViewController = segue.destinationViewController as! PlaySoundsViewController
      let data = sender as! RecordedAudio
      playSoundsVC.receivedAudio = data
    }
    // Transfers recorded audio to app's next stage
  }
  
  @IBAction func stopRecord(sender: UIButton) {
    RecordingInProgress.hidden = true
    audioRecorder.stop()
    var audioSession = AVAudioSession.sharedInstance()
    audioSession.setActive(false, error: nil)
  }

}

