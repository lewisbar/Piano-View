//
//  OctaveControl.swift
//  Piano View
//
//  Created by Lennart Wisbar on 04.05.16.
//  Copyright © 2016 Lennart Wisbar. All rights reserved.
//

import UIKit

/*
protocol OctaveControlDelegate {
    func createOctaveControlOutlet(_ sender: OctaveControl)
}
*/

@IBDesignable class OctaveControl: UISegmentedControl {
    
//    var delegate: OctaveControlDelegate?
//    let octaves = ["1", "2", "3", "4", "5", "6"]
    
    override init(items: [Any]?) {
        super.init(items: items)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }

}
