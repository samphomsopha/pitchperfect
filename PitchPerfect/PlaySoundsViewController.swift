//
//  PlaySoundsViewController.swift
//  PitchPerfect
//
//  Created by sam phomsopha on 5/30/16.
//  Copyright © 2016 Sam Phomsopha. All rights reserved.
//

import UIKit
import AVFoundation

class PlaySoundsViewController: UIViewController {
    
    @IBOutlet weak var OuterStackView: UIStackView!
    @IBOutlet weak var innerStackView1: UIStackView!
    @IBOutlet weak var innerStackView2: UIStackView!
    @IBOutlet weak var innerStackView3: UIStackView!
    @IBOutlet weak var innerStackView4: UIStackView!
    
    @IBOutlet weak var snailButton: UIButton!
    @IBOutlet weak var chipmunkButton: UIButton!
    @IBOutlet weak var rabbitButton: UIButton!
    @IBOutlet weak var vaderButton: UIButton!
    @IBOutlet weak var echoButton: UIButton!
    @IBOutlet weak var reverbButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!
    
    
    var recordedAudioURL: NSURL!
    var audioFile: AVAudioFile!
    var audioEngine: AVAudioEngine!
    var audioPlayerNode: AVAudioPlayerNode!
    var stopTimer: NSTimer!
    
    enum ButtonType: Int {case Slow = 0, Fast, Chipmunk, Vader, Echo, Reverb}
    @IBAction func playSoundForButton(sender: UIButton) {
        print("Play Sound Button Pressed")
        switch(ButtonType(rawValue: sender.tag)!) {
        case .Slow:
            playSound(rate: 0.5)
        case .Fast:
            playSound(rate: 1.5)
        case .Chipmunk:
            playSound(pitch: 1000)
        case .Vader:
            playSound(pitch: -1000)
        case .Echo:
            playSound(echo: true)
        case .Reverb:
            playSound(reverb: true)
        }
        
        configureUI(.Playing)
        
    }
    
    
    @IBAction func stopButtonPressed(sender: AnyObject) {
        print("Stop Audio Button PRessed")
        stopAudio()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("PlaySoundsViewController loaded")
        configureStackViewOrientation()
        setupAudio()
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        configureUI(.NotPlaying)
    }
    
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        coordinator.animateAlongsideTransition({ (context) -> Void in
            self.configureStackViewOrientation()
            }, completion: nil)
    }
    
    func configureStackViewOrientation() {
        let orientation = UIApplication.sharedApplication().statusBarOrientation
        if orientation.isPortrait {
            OuterStackView.axis = .Vertical
            setInnerStackViewsAxis(.Horizontal)
        } else {
            OuterStackView.axis = .Horizontal
            setInnerStackViewsAxis(.Vertical)
        }
    }
    
    func setInnerStackViewsAxis(axisStyle: UILayoutConstraintAxis)  {
        self.innerStackView1.axis = axisStyle
        self.innerStackView2.axis = axisStyle
        self.innerStackView3.axis = axisStyle
        self.innerStackView4.axis = axisStyle
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
