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


func speak(phrase: String){ //функция проговаривания
    let utterance = AVSpeechUtterance(string: phrase)
    utterance.voice = AVSpeechSynthesisVoice(language: "ru-RU")
    synthesizer.speak(utterance)
}
func pauseSpeak(){ //остановка проговаривания
    synthesizer.pauseSpeaking(at: .immediate)
}
func stopSpeaking(){
    synthesizer.stopSpeaking(at: .immediate) // Stop --- Similar to the `pauseSpeaking(at: .immediate)`
}

func speakPhantom(phrase: String){
    let utterance = AVSpeechUtterance(string: phrase)
    utterance.voice = AVSpeechSynthesisVoice(language: "ru-RU")
    utterance.preUtteranceDelay = 3
    synthesizer.speak(utterance)
}


func continueSpeaking(){ //продолжение проговаривания
    synthesizer.continueSpeaking();
}
