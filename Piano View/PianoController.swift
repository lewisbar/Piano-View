//
//  PianoController.swift
//  Piano View
//
//  Created by Lennart Wisbar on 20.04.16.
//  Copyright © 2016 Lennart Wisbar. All rights reserved.
//

import UIKit

class PianoController: KeysViewDelegate {
    
    var pianoView: PianoView
    let pianoModel = PianoModel()
    let notes = ["C", "C#", "D", "D#", "E", "F", "F#", "G", "G#", "A", "A#", "B"]
    
    init(withPianoView pianoView: PianoView) {
        self.pianoView = pianoView
    }
    
/*    func createPianoViewOutlet(_ sender: PianoView) {
        pianoView = sender
    }
    
    func createOctaveControlOutlet(_ sender: OctaveControl) {
        octaveControl = sender
    }
 */
    
    // TODO: Display the correct octave
    func touchesBegan(onKey key: UIView) {
        pianoModel.play(notes[key.tag] + String(pianoView.octaveControl.selectedSegmentIndex))
    }
    
    func touchesMoved(onKey key: UIView) {
        pianoModel.play(notes[key.tag] + String(pianoView.octaveControl.selectedSegmentIndex))
    }
    
    func touchesEnded(onKey key: UIView) {
        pianoModel.release(notes[key.tag] + String(pianoView.octaveControl.selectedSegmentIndex))
    }
    
    func touchesRemoved(fromKey key: UIView) {
        pianoModel.release(notes[key.tag] + String(pianoView.octaveControl.selectedSegmentIndex))
    }
}
