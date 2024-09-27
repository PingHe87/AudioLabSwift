//
//  ViewController.swift
//  AudioLabSwift
//
//  Created by Eric Larson 
//  Copyright © 2020 Eric Larson. All rights reserved.
//

import UIKit
import Metal


let AUDIO_BUFFER_SIZE = 1024*4


class ViewController: UIViewController {

    
    let audio = AudioModel(buffer_size: AUDIO_BUFFER_SIZE)
    lazy var graph:MetalGraph? = {
        return MetalGraph(mainView: self.view)
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // add in graphs for display
        graph?.addGraph(withName: "fft",
                        shouldNormalize: true,
                        numPointsInGraph: AUDIO_BUFFER_SIZE/2)
        
        graph?.addGraph(withName: "time",
            shouldNormalize: false,
            numPointsInGraph: AUDIO_BUFFER_SIZE)
        
        //FM2 create a graph 20 points long
        graph?.addGraph(withName: "equalizer",
                        shouldNormalize: true,
                        numPointsInGraph: 20)
        
//        // just start up the audio model here
//        audio.startMicrophoneProcessing(withFps: 10)
//        //audio.startProcesingAudioFileForPlayback()
//        audio.startProcessingSinewaveForPlayback(withFreq: 630.0)
//        audio.play()
        
        //FM2 deal with mp3 rather than microphone
        audio.startProcesingAudioFileForPlayback()
        audio.play()
        
        // run the loop for updating the graph peridocially
        Timer.scheduledTimer(timeInterval: 0.05, target: self,
            selector: #selector(self.updateGraph),
            userInfo: nil,
            repeats: true)
        
        

       
    }
    
    // FM2
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // puase the audio
        audio.pauseAudio()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // restart the audio
        audio.playAudio()
    }
    
    
//    @objc
//    func updateGraph(){
//        self.graph?.updateGraph(
//            data: self.audio.fftData,
//            forKey: "fft"
//        )
//        
//        self.graph?.updateGraph(
//            data: self.audio.timeData,
//            forKey: "time"
//        )
//        
//        // FM2: update the graph
//            self.graph?.updateGraph(
//                data: self.audio.equalizerData,
//                forKey: "equalizer"
//            )
//        
//    }
    @objc
    func updateGraph(){
        print("Updating FFT graph with data:", self.audio.fftData[0..<min(10, self.audio.fftData.count)])
        
        self.graph?.updateGraph(
            data: self.audio.fftData,
            forKey: "fft"
        )
        
        print("Updating Time graph with data:", self.audio.timeData[0..<min(10, self.audio.timeData.count)])
        
        self.graph?.updateGraph(
            data: self.audio.timeData,
            forKey: "time"
        )
        
        print("Updating Equalizer graph with data:", self.audio.equalizerData[0..<min(10, self.audio.equalizerData.count)])
        
        self.graph?.updateGraph(
            data: self.audio.equalizerData,
            forKey: "equalizer"
        )
    }



    
    

}

