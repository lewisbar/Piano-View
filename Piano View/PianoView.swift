//
//  PianoView.swift
//  Piano View
//
//  Created by Lennart Wisbar on 01.02.16.
//  Copyright © 2016 Lennart Wisbar. All rights reserved.
//

/*
 Diese Klasse soll dem PianoController mitteilen, wenn eine Taste gedrückt oder losgelassen oder auf sie herauf- oder von ihr heruntergeslidet wird. Natürlich auch um welche Taste es sich handelt. Das gilt auch für mehrere Tasten, die gleichzeitig berührt werden. Die Entscheidung, was mit diesem Ereignis gemacht wird, trifft der Controller. Der Controller entscheidet z.B., ob mehrere Töne zusammen gespielt werden oder nur einer, ob man ein Glissando machen kann usw. Auf diese Weise ist diese Klasse für Pianos mit den verschiedensten Zwecken verwendbar.
 Aus Gründen der Wiederverwertbarkeit gehört der Oktavselektor nicht mit in diese Klasse, sondern wird separat eingebaut. Der Controller wertet dann die Werte beider Klassen aus.
*/

import UIKit

protocol PianoViewDelegate: class {
    func createPianoViewOutlet(sender: PianoView)
    func touchesBeganOnKey(key: UIView)
    func touchesMovedOnKey(key: UIView)
    func touchesEndedOnKey(key: UIView)
    func touchesRemovedFromKey(key: UIView)
}

@IBDesignable class PianoView: UIView {

    // MARK: Instance Variables
    weak var delegate: PianoViewDelegate?
    
    var allKeys = [UIView]()
    var whiteKeys = [UIView]()
    var blackKeys = [UIView]()
    var c = UIView()
    var cis = UIView()
    var d = UIView()
    var dis = UIView()
    var e = UIView()
    var f = UIView()
    var fis = UIView()
    var g = UIView()
    var gis = UIView()
    var a = UIView()
    var ais = UIView()
    var b = UIView()
    
    @IBInspectable var whiteKeyColor: UIColor = UIColor.whiteColor() {
        didSet {
            for (_, key) in whiteKeys.enumerate() {
                key.backgroundColor = whiteKeyColor
            }
        }
    }
    @IBInspectable var whiteKeyBorderColor: UIColor = UIColor.blackColor() {
        didSet {
            for (_, key) in whiteKeys.enumerate() {
                key.layer.borderColor = whiteKeyBorderColor.CGColor
            }
        }
    }
    @IBInspectable var blackKeyColor: UIColor = UIColor.blackColor() {
        didSet {
            for (_, key) in blackKeys.enumerate() {
                key.backgroundColor = blackKeyColor
            }
        }
    }
    
    //MARK: Initializers
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        addKeys()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addKeys()
    }
    
    //MARK: Setup
    func addKeys() {
        // Add white keys.
        whiteKeys += [c, d, e, f, g, a, b]
        for key in whiteKeys {
            key.backgroundColor = whiteKeyColor
            key.layer.borderWidth = 1
            key.layer.borderColor = whiteKeyBorderColor.CGColor
            addSubview(key)
            key.userInteractionEnabled = true
        }
        // Add black keys.
        blackKeys += [cis, dis, fis, gis, ais]
        for key in blackKeys {
            key.backgroundColor = blackKeyColor
            addSubview(key)
            key.userInteractionEnabled = true
        }
        allKeys = blackKeys + whiteKeys
        delegate?.createPianoViewOutlet(self)
        addTagsToKeys()
    }
    
    func addTagsToKeys() {
        c.tag = 0
        cis.tag = 1
        d.tag = 2
        dis.tag = 3
        e.tag = 4
        f.tag = 5
        fis.tag = 6
        g.tag = 7
        gis.tag = 8
        a.tag = 9
        ais.tag = 10
        b.tag = 11
    }

    override func layoutSubviews() {
        layoutWhiteKeys()
        layoutBlackKeys()
    }
    
    func layoutWhiteKeys() {
        let whiteKeyWidth = frame.size.width/7
        let whiteKeyHeight = frame.size.height
        var whiteKeyFrame = CGRect(x: 0, y: 0, width: whiteKeyWidth, height: whiteKeyHeight)

        // Offset each white key's origin by the width of the key.
        for (index, key) in whiteKeys.enumerate() {
            whiteKeyFrame.origin.x = CGFloat(index) * whiteKeyWidth
            key.frame = whiteKeyFrame
        }
    }
    
    func layoutBlackKeys() {
        let whiteKeyWidth = frame.size.width/7
        let whiteKeyHeight = frame.size.height
        let blackKeyWidth = whiteKeyWidth * 0.8
        let blackKeyHeight = whiteKeyHeight/2
        var blackKeyFrame = CGRect(x: 0, y: 0, width: blackKeyWidth, height: blackKeyHeight)
        
        for (index, key) in blackKeys.enumerate() {
            switch index {
            case 0: blackKeyFrame.origin.x = CGFloat(1*whiteKeyWidth - blackKeyWidth/2)
            case 1: blackKeyFrame.origin.x = CGFloat(2*whiteKeyWidth - blackKeyWidth/2)
            case 2: blackKeyFrame.origin.x = CGFloat(4*whiteKeyWidth - blackKeyWidth/2)
            case 3: blackKeyFrame.origin.x = CGFloat(5*whiteKeyWidth - blackKeyWidth/2)
            case 4: blackKeyFrame.origin.x = CGFloat(6*whiteKeyWidth - blackKeyWidth/2)
            default: print("Index out of bounds. PianoView.layoutBlackKeys() is calling for too many black keys.")
            }
            key.frame = blackKeyFrame
        }
    }
    
    //MARK: Handle touch events
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        super.touchesBegan(touches, withEvent: event)

        for key in allKeys {
            for touch in touches {
                let point = touch.locationInView(key)
                if key.pointInside(point, withEvent: event) {
                    delegate?.touchesBeganOnKey(key)
                    setKeyToPressedState(key)
                    return
                }
            }
        }
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        super.touchesMoved(touches, withEvent: event)
        
        for touch in touches {
            var touchIsOnBlackKey = false
            for blackKey in blackKeys {
                let point = touch.locationInView(blackKey)
                if blackKey.pointInside(point, withEvent: event) {
                    delegate?.touchesMovedOnKey(blackKey)
                    setKeyToPressedState(blackKey)
                    touchIsOnBlackKey = true
                } else if blackKey.backgroundColor != blackKeyColor {
                    delegate?.touchesRemovedFromKey(blackKey)
                    setKeyToReleasedState(blackKey)
                }
            }
            for whiteKey in whiteKeys {
                let point = touch.locationInView(whiteKey)
                if !touchIsOnBlackKey && whiteKey.pointInside(point, withEvent: event) {
                    delegate?.touchesMovedOnKey(whiteKey)
                    setKeyToPressedState(whiteKey)
                } else if whiteKey.backgroundColor != whiteKeyColor {
                    delegate?.touchesRemovedFromKey(whiteKey)
                    setKeyToReleasedState(whiteKey)
                }
            }
        }
    }

    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        super.touchesEnded(touches, withEvent: event)
        
        for key in allKeys {
            for touch in touches {
                let point = touch.locationInView(key)
                if key.pointInside(point, withEvent: event) {
                    delegate?.touchesEndedOnKey(key)
                    setKeyToReleasedState(key)
                    return
                }
            }
        }
    }
    
    //MARK: Color changes
    func setKeyToPressedState(key: UIView) {
        key.backgroundColor = UIColor.grayColor()
    }
    
    func setKeyToReleasedState(key: UIView) {
        if whiteKeys.contains(key) {
            key.backgroundColor = whiteKeyColor
        } else {
            key.backgroundColor = blackKeyColor
        }
    }
}
