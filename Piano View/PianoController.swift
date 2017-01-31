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
    
    func createPianoViewOutlet(_ sender: PianoView) {
        pianoView = sender
    }
    
    func touchesBegan(onKey key: UIView) {
        pianoModel.play(notes[key.tag] + "4")
    }
    
    func touchesMoved(onKey key: UIView) {
        pianoModel.play(notes[key.tag] + "4")
    }
    
    func touchesEnded(onKey key: UIView) {
        pianoModel.release(notes[key.tag] + "4")
    }
    
    func touchesRemoved(fromKey key: UIView) {
        pianoModel.release(notes[key.tag] + "4")
    }
}
