//
//  ViewController.swift
//  Piano View
//
//  Created by Lennart Wisbar on 10.04.16.
//  Copyright © 2016 Lennart Wisbar. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet var pianoView: PianoView!
    private var pianoController: PianoController!
    private let audioEngine = AudioEngine()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pianoController = PianoController(withPianoView: pianoView, delegate: audioEngine)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

