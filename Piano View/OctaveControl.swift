//
//  OctaveControl.swift
//  Piano View
//
//  Created by Lennart Wisbar on 04.05.16.
//  Copyright © 2016 Lennart Wisbar. All rights reserved.
//

import UIKit

class OctaveControl: UISegmentedControl {
    
    let octaves = ["1", "2", "3", "4", "5", "6"]
    
    override init(items: [AnyObject]?) {
        super.init(items: items)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

}
