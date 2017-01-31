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
    @IBOutlet var octaveControl: OctaveControl!
    let pianoController = PianoController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pianoView.delegate = pianoController
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

