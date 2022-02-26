//
//  ViewController.swift
//  6 Sense
//
//  Created by Sasha on 8/18/21.
//

import UIKit
import AVFoundation
import Speech
import AVKit


let synthesizer = AVSpeechSynthesizer()


func speak(phrase: String){
    let utterance = AVSpeechUtterance(string: phrase)
    utterance.voice = AVSpeechSynthesisVoice(language: "ru-RU")
    synthesizer.speak(utterance)
}
func pauseSpeak(){
    synthesizer.pauseSpeaking(at: AVSpeechBoundary.immediate)
}
func continueSpeaking(){
    synthesizer.continueSpeaking();
}
