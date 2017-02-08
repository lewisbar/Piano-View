//
//  ViewController.swift
//  Piano View
//
//  Created by Lennart Wisbar on 10.04.16.
//  Copyright © 2016 Lennart Wisbar. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

//TODO: Hier PianoView instantiieren. Dann einen PianoController instantiieren und ihm dabei den PianoView übergeben. PianoView erstellt seinerseits KeysView und OctaveControl. PianoController kann über PianoView auf KeysView und OctaveControl zugreifen.
    
    @IBOutlet var pianoView: PianoView!
    var pianoController: PianoController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pianoController = PianoController(withPianoView: pianoView)
        pianoView.keysView.delegate = pianoController
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

