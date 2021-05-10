//
//  SoundManager.swift
//  MatchApp
//
//  Created by Brian Dilts on 5/10/21.
//

import Foundation
import AVFoundation

class SoundManager {
    
    var audioPlayer:AVAudioPlayer?
    
    enum SoundEffect {
        
        case flip
        case match
        case nomatch
        case shuffle
        
    }
    
    func playSound(effect:SoundEffect) {
        
    }
    
}
