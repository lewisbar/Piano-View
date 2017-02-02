//
//  PianoWithOctavesView.swift
//  Piano View
//
//  Created by Lennart Wisbar on 02.02.17.
//  Copyright © 2017 Lennart Wisbar. All rights reserved.
//

import UIKit

@IBDesignable class PianoWithOctavesView: UIView {

    var octaveControl = OctaveControl(items: ["1", "2", "3", "4", "5", "6"])
    var pianoView = PianoView()
    
    //MARK: Initializers
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        addSubviews()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviews()
    }
    
    func addSubviews() {
        addSubview(octaveControl)
        addSubview(pianoView)
    }
    
    //MARK: Layout
    override func layoutSubviews() {
        
        let octaveControlHeight = octaveControl.intrinsicContentSize.height
        let pianoViewHeight = frame.height - octaveControlHeight
        
        octaveControl.frame = CGRect(x: 0, y: 0, width: frame.width, height: octaveControlHeight)
        pianoView.frame = CGRect(x: 0, y: octaveControlHeight, width: frame.width, height: pianoViewHeight)
    }
}
