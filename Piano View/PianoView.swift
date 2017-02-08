//
//  PianoView.swift
//  Piano View
//
//  Created by Lennart Wisbar on 02.02.17.
//  Copyright © 2017 Lennart Wisbar. All rights reserved.
//

import UIKit

@IBDesignable class PianoView: UIView {

    var octaveControl = UISegmentedControl(items: ["1", "2", "3", "4", "5", "6"])
    var keysView = KeysView()
    
    //MARK: IBInspectable
    override var backgroundColor: UIColor? {
        didSet {
            keysView.whiteKeyColor = backgroundColor ?? UIColor.white
            octaveControl.backgroundColor = backgroundColor ?? UIColor.white
        }
    }
    
    override var tintColor: UIColor! {
        didSet {
            keysView.blackKeyColor = tintColor
            octaveControl.tintColor = tintColor
        }
    }
    
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
        // Remove rounded corners
        octaveControl.layer.borderWidth = 1.5
        
        //Select initial segment
        octaveControl.selectedSegmentIndex = 3
        
        keysView.blackKeyColor = tintColor
        //Because, for some reason, the tintColor setter is never called (TODO?)
        
        addSubview(octaveControl)
        addSubview(keysView)
    }
    
    //MARK: Layout
    override func layoutSubviews() {
        
        let octaveControlHeight = octaveControl.intrinsicContentSize.height
        let pianoViewHeight = frame.height - octaveControlHeight
        
        octaveControl.frame = CGRect(x: 0, y: 0, width: frame.width, height: octaveControlHeight)
        keysView.frame = CGRect(x: 0, y: octaveControlHeight, width: frame.width, height: pianoViewHeight)
    }
}
