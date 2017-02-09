//
//  PianoController.swift
//  Piano View
//
//  Created by Lennart Wisbar on 20.04.16.
//  Copyright © 2016 Lennart Wisbar. All rights reserved.
//

import UIKit

protocol PianoDelegate {
    func play(note: String)
    func release(note: String)
}

class PianoController: KeysViewDelegate {
    
    private let pianoView: PianoView
    private var delegate: PianoDelegate
    private let notes = ["C", "C#", "D", "D#", "E", "F", "F#", "G", "G#", "A", "A#", "B"]
    
    init(withPianoView pianoView: PianoView, delegate: PianoDelegate) {
        self.pianoView = pianoView
        self.delegate = delegate
        pianoView.keysView.delegate = self
    }
    
    // MARK: - KeysViewDelegate
    func touchesBegan(onKey key: UIView) {
        delegate.play(note: notes[key.tag] + String(pianoView.octaveControl.selectedSegmentIndex+1))
    }
    
    func touchesMoved(onKey key: UIView) {
        delegate.play(note: notes[key.tag] + String(pianoView.octaveControl.selectedSegmentIndex+1))
    }
    
    func touchesEnded(onKey key: UIView) {
        delegate.release(note: notes[key.tag] + String(pianoView.octaveControl.selectedSegmentIndex+1))
    }
    
    func touchesRemoved(fromKey key: UIView) {
        delegate.release(note: notes[key.tag] + String(pianoView.octaveControl.selectedSegmentIndex+1))
    }
}
