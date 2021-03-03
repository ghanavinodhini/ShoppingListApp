//
//  SpeechData.swift
//  ShoppingList
//
//  Created by Ghanavinodhini Chandrasekaran on 2021-02-13.
//

import Foundation
import Speech
import SwiftUI

struct Speech{
    var outputText:String = ""
}

public class SpeechData:ObservableObject
{
    @Published var isRecording:Bool = false
    @Published var button = SpeechButton()
    @Published var speech = Speech()
    
    let speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "en-US"))
    var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    let authStat = SFSpeechRecognizer.authorizationStatus()
    var recognitionTask: SFSpeechRecognitionTask?
    let audioEngine = AVAudioEngine()
    
    init(){
        
        //Requests auth from User
        SFSpeechRecognizer.requestAuthorization{ authStatus in
            OperationQueue.main.addOperation
            {
                switch authStatus
                {
                case .authorized:
                    break
                    
                case .denied:
                    break
                    
                case .restricted:
                    break
                    
                case .notDetermined:
                    break
                    
                default:
                    break
                }
            }
        }// end of auth request
        
        recognitionTask?.cancel()
        self.recognitionTask = nil
    }
    
    // returns the Speech button
    func getButton()->SpeechButton{
        return button
    }
    
    // starts the recording sequence
    func startRecording(){
        
        // restarts the text
        self.speech.outputText = ""
        
        // Configure the audio session for the app.
        let audioSession = AVAudioSession.sharedInstance()
        let inputNode = audioEngine.inputNode
        
        // try catch to start audio session
        do{
            try audioSession.setCategory(.record, mode: .measurement, options: .duckOthers)
            try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
        }catch{
            print("ERROR: - Audio Session Failed!")
        }
        
        // Configure the microphone input and request auth
        let recordingFormat = inputNode.outputFormat(forBus: 0)
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer: AVAudioPCMBuffer, when: AVAudioTime) in
            self.recognitionRequest?.append(buffer)
        }
        
        audioEngine.prepare()
        
        do{
            try audioEngine.start()
        }catch{
            print("ERROR: - Audio Engine failed to start")
        }
        
        // Create and configure the speech recognition request.
        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        guard let recognitionRequest = recognitionRequest else {
            print("Unable to create RecognitionRequest object")
            return
        }
        recognitionRequest.shouldReportPartialResults = true
        
        // Create a recognition task for the speech recognition session.
        recognitionTask = speechRecognizer?.recognitionTask(with: recognitionRequest){ result, error in
            if (result != nil){
                self.speech.outputText = (result?.transcriptions[0].formattedString)!
            }
            if let result = result{
                // Update the text view with the results.
                self.speech.outputText = result.transcriptions[0].formattedString
            }
            if error != nil {
                // Stop recognizing speech if there is a problem.
                self.audioEngine.stop()
                inputNode.removeTap(onBus: 0)
                self.recognitionRequest = nil
                self.recognitionTask = nil
                
            }
        }
    }
    
    // Stop recording
    func stopRecording(){
        // resets the variables
        audioEngine.stop()
        recognitionRequest?.endAudio()
        self.audioEngine.inputNode.removeTap(onBus: 0)
        self.recognitionTask?.cancel()
        self.recognitionTask = nil
    }
    
    // gets the status of authorization
    func getSpeechStatus()->String{
        
        switch authStat{
        
        case .authorized:
            return "Authorized"
            
        case .notDetermined:
            return "Not yet Determined"
            
        case .denied:
            return "Denied - Close the App"
            
        case .restricted:
            return "Restricted - Close the App"
            
        default:
            return "ERROR: No Status Defined"
            
        }// end of switch
        
    } // end of get speech status
    
}
