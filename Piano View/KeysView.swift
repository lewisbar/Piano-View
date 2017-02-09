//
//  KeysView.swift
//  Piano View
//
//  Created by Lennart Wisbar on 01.02.16.
//  Copyright © 2016 Lennart Wisbar. All rights reserved.
//

/*
 This class tells the PianoController when a key is pressed or released, slided upon or slided away from. And, of course, which key it was. This should also work for several keys pressed simultanously.
 The PianoController decides what to do with these events. For example, the controller decides if you can hear only one note at a time, if you can make a glissando etc. The controller can be modified or replaced to serve different purposes.
 The PianoView prepares the KeysView optically. The PianoController then works with the KeysView.
 */

import UIKit

protocol KeysViewDelegate {
    func touchesBegan(onKey: UIView)
    func touchesMoved(onKey: UIView)
    func touchesEnded(onKey: UIView)
    func touchesRemoved(fromKey: UIView)
}

class KeysView: UIView {

    // MARK: - Instance Variables
    var delegate: KeysViewDelegate?
    
    private var allKeys = [UIView]()
    private var whiteKeys = [UIView]()
    private var blackKeys = [UIView]()
    private var c = UIView()
    private var cis = UIView()
    private var d = UIView()
    private var dis = UIView()
    private var e = UIView()
    private var f = UIView()
    private var fis = UIView()
    private var g = UIView()
    private var gis = UIView()
    private var a = UIView()
    private var ais = UIView()
    private var b = UIView()
    
    var whiteKeyColor: UIColor = UIColor.white {
        didSet {
            for whiteKey in whiteKeys {
                whiteKey.backgroundColor = whiteKeyColor
            }
        }
    }
    
    var blackKeyColor: UIColor = UIColor.black {
        didSet {
            for blackKey in blackKeys {
                blackKey.backgroundColor = blackKeyColor
            }
            for whiteKey in whiteKeys {
                whiteKey.layer.borderColor = blackKeyColor.cgColor
            }
        }
    }
    
    // MARK: - Initializers
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        addKeys()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addKeys()
    }
    
    // MARK: - Setup
    private func addKeys() {
        // Add white keys.
        whiteKeys = [c, d, e, f, g, a, b]
        for key in whiteKeys {
            key.backgroundColor = whiteKeyColor
            key.layer.borderWidth = 1
            key.layer.borderColor = blackKeyColor.cgColor
            addSubview(key)
            key.isUserInteractionEnabled = true
        }
        // Add black keys.
        blackKeys = [cis, dis, fis, gis, ais]
        for key in blackKeys {
            key.backgroundColor = blackKeyColor
            addSubview(key)
            key.isUserInteractionEnabled = true
        }
        allKeys = blackKeys + whiteKeys
        //  Black first so the black keys aren't "tapped through", letting the whiteKeys "rob" the touch event.
        
        addTagsToKeys()
    }
    
    private func addTagsToKeys() {
        // Tags are for the controller to work with. They are the only way to get the keys in the expected order, because allKeys is ordered black keys first due to correct handling of touch events.
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
    
    private func layoutWhiteKeys() {
        let whiteKeyWidth = frame.size.width/7
        let whiteKeyHeight = frame.size.height
        var whiteKeyFrame = CGRect(x: 0, y: 0, width: whiteKeyWidth, height: whiteKeyHeight)

        // Offset each white key's origin by the width of the key.
        for (index, key) in whiteKeys.enumerated() {
            whiteKeyFrame.origin.x = CGFloat(index) * whiteKeyWidth
            key.frame = whiteKeyFrame
        }
    }
    
    private func layoutBlackKeys() {
        let whiteKeyWidth = frame.size.width/7
        let whiteKeyHeight = frame.size.height
        let blackKeyWidth = whiteKeyWidth * 0.8
        let blackKeyHeight = whiteKeyHeight/2
        var blackKeyFrame = CGRect(x: 0, y: 0, width: blackKeyWidth, height: blackKeyHeight)
        
        for (index, key) in blackKeys.enumerated() {
            switch index {
            case 0: blackKeyFrame.origin.x = CGFloat(1*whiteKeyWidth - blackKeyWidth/2)
            case 1: blackKeyFrame.origin.x = CGFloat(2*whiteKeyWidth - blackKeyWidth/2)
            case 2: blackKeyFrame.origin.x = CGFloat(4*whiteKeyWidth - blackKeyWidth/2)
            case 3: blackKeyFrame.origin.x = CGFloat(5*whiteKeyWidth - blackKeyWidth/2)
            case 4: blackKeyFrame.origin.x = CGFloat(6*whiteKeyWidth - blackKeyWidth/2)
            default: print("Index out of bounds. KeysView.layoutBlackKeys() is calling for too many black keys.")
            }
            key.frame = blackKeyFrame
        }
    }
    
    // MARK: - Handle touch events
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)

        for key in allKeys {
            for touch in touches {
                let point = touch.location(in: key)
                if key.point(inside: point, with: event) {
                    delegate?.touchesBegan(onKey: key)
                    setKeyToPressedState(key)
                    return
                }
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        
        for touch in touches {
            var isTouchOnBlackKey = false
            for blackKey in blackKeys {
                let point = touch.location(in: blackKey)
                if blackKey.point(inside: point, with: event) {
                    delegate?.touchesMoved(onKey: blackKey)
                    setKeyToPressedState(blackKey)
                    isTouchOnBlackKey = true
                } else if blackKey.backgroundColor != blackKeyColor {
                    delegate?.touchesRemoved(fromKey: blackKey)
                    setKeyToReleasedState(blackKey)
                }
            }
            for whiteKey in whiteKeys {
                let point = touch.location(in: whiteKey)
                if !isTouchOnBlackKey && whiteKey.point(inside: point, with: event) {
                    delegate?.touchesMoved(onKey: whiteKey)
                    setKeyToPressedState(whiteKey)
                } else if whiteKey.backgroundColor != whiteKeyColor {
                    delegate?.touchesRemoved(fromKey: whiteKey)
                    setKeyToReleasedState(whiteKey)
                }
            }
        }
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        
        for key in allKeys {
            for touch in touches {
                let point = touch.location(in: key)
                if key.point(inside: point, with: event) {
                    delegate?.touchesEnded(onKey: key)
                    setKeyToReleasedState(key)
                    return
                }
            }
        }
    }
    
    // MARK: - Color changes
    private func setKeyToPressedState(_ key: UIView) {
        key.backgroundColor = UIColor.gray
    }
    
    private func setKeyToReleasedState(_ key: UIView) {
        if whiteKeys.contains(key) {
            key.backgroundColor = whiteKeyColor
        } else {
            key.backgroundColor = blackKeyColor
        }
    }
}
