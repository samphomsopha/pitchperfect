//
//  RecordSoundsViewController.swift
//  PitchPerfect
//
//  Created by Sam Phomsopha on 5/12/16.
//  Copyright © 2016 Sam Phomsopha. All rights reserved.
//

import UIKit
import AVFoundation

// raw values correspond to sender tags
enum RecordingState { case Recording, NotRecording }

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {

    @IBOutlet weak var recordingLabel: UILabel!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var stopRecordingButton: UIButton!
    
    var audioRecorder: AVAudioRecorder!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        stopRecordingButton.enabled = false
    }

    @IBAction func recordAudio(sender: AnyObject) {
        setRecordingState(.Recording)
        let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
        let recordingName = "recordedVoice.wav"
        let pathArray = [dirPath, recordingName]
        let filePath = NSURL.fileURLWithPathComponents(pathArray)
        print(filePath)
        
        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSessionCategoryPlayAndRecord)
        
        try! audioRecorder = AVAudioRecorder(URL: filePath!, settings: [:])
        audioRecorder.delegate = self
        audioRecorder.meteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
        
    }

    @IBAction func stopRecording(sender: AnyObject) {
        print("Stop Recording")
        setRecordingState(.NotRecording)
        
        audioRecorder.stop()
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)
    }
    
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder, successfully flag: Bool) {
        print("Finished recording")
        if (flag) {
            performSegueWithIdentifier("stopRecording", sender: audioRecorder.url)
        } else {
            print("Saving audio file failed")
        }
    }
    
    func setRecordingState(recordState: RecordingState) {
        switch(recordState) {
        case .Recording:
            recordingLabel.text = "Recording In Processing"
        case .NotRecording:
            recordingLabel.text = "Tap To Record"
        }
        
        stopRecordingButton.enabled = stopRecordingButton.enabled ? false: true
        recordButton.enabled = recordButton.enabled ? false: true
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "stopRecording") {
            let playSoundsVC = segue.destinationViewController as! PlaySoundsViewController
            let recordedAudioURL = sender as! NSURL
            
            playSoundsVC.recordedAudioURL = recordedAudioURL
        }
    }
}

