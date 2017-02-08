//
//  KeysView.swift
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

protocol KeysViewDelegate {
    func touchesBegan(onKey: UIView)
    func touchesMoved(onKey: UIView)
    func touchesEnded(onKey: UIView)
    func touchesRemoved(fromKey: UIView)
}

class KeysView: UIView {

    // MARK: - Instance Variables
    var delegate: KeysViewDelegate?
    
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
    //TODO?: No need to name the keys. I could refactor this, using loops in addKeys(). But giving the keys individual names could be more readable and easier to understand.
    
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
    
    //MARK: - Initializers
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        addKeys()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addKeys()
    }
    
    //MARK: - Setup
    func addKeys() {
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
        for (index, key) in whiteKeys.enumerated() {
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
    
    //MARK: - Handle touch events
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
    
    //MARK: - Color changes
    func setKeyToPressedState(_ key: UIView) {
        key.backgroundColor = UIColor.gray
    }
    
    func setKeyToReleasedState(_ key: UIView) {
        if whiteKeys.contains(key) {
            key.backgroundColor = whiteKeyColor
        } else {
            key.backgroundColor = blackKeyColor
        }
    }
}
