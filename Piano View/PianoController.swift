//
//  PianoController.swift
//  Piano View
//
//  Created by Lennart Wisbar on 20.04.16.
//  Copyright © 2016 Lennart Wisbar. All rights reserved.
//

import UIKit

class PianoController: PianoViewDelegate {
    
    var pianoView: PianoView
    var octaveControl: OctaveControl
    let pianoModel = PianoModel()
    let notes = ["C", "C#", "D", "D#", "E", "F", "F#", "G", "G#", "A", "A#", "B"]
//    var currentOctave: Int = {
//        return octaveControl.selectedSegmentIndex
//    }
    
    init(withPianoView pianoView: PianoView, octaveControl: OctaveControl) {
        self.pianoView = pianoView
        self.octaveControl = octaveControl
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
        pianoModel.play(notes[key.tag] + String(octaveControl.selectedSegmentIndex))
    }
    
    func touchesMoved(onKey key: UIView) {
        pianoModel.play(notes[key.tag] + String(octaveControl.selectedSegmentIndex))
    }
    
    func touchesEnded(onKey key: UIView) {
        pianoModel.release(notes[key.tag] + String(octaveControl.selectedSegmentIndex))
    }
    
    func touchesRemoved(fromKey key: UIView) {
        pianoModel.release(notes[key.tag] + String(octaveControl.selectedSegmentIndex))
    }
}
