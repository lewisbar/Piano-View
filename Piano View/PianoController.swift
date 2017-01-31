//
//  PianoController.swift
//  Piano View
//
//  Created by Lennart Wisbar on 20.04.16.
//  Copyright © 2016 Lennart Wisbar. All rights reserved.
//

import UIKit

class PianoController: PianoViewDelegate {
    
    var pianoView = PianoView()
    let pianoModel = PianoModel()
    let notes = ["C", "C#", "D", "D#", "E", "F", "F#", "G", "G#", "A", "A#", "B"]
    
    func createPianoViewOutlet(sender: PianoView) {
        pianoView = sender
    }
    
    func touchesBeganOnKey(key: UIView) {
        pianoModel.playNote(notes[key.tag] + "4")
    }
    
    func touchesMovedOnKey(key: UIView) {
        pianoModel.playNote(notes[key.tag] + "4")
    }
    
    func touchesEndedOnKey(key: UIView) {
        pianoModel.releaseNote(notes[key.tag] + "4")
    }
    
    func touchesRemovedFromKey(key: UIView) {
        pianoModel.releaseNote(notes[key.tag] + "4")
    }
}