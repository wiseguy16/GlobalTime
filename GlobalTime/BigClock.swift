//
//  BigClock.swift
//  GlobalTime
//
//  Created by Gregory Weiss on 8/22/16.
//  Copyright © 2016 Gregory Weiss. All rights reserved.
//


import UIKit
import Foundation

let borderWidth2: CGFloat = 2
let borderAlpha2: CGFloat = 1.0
let graduationOffset2: CGFloat = 10
let graduationLength2: CGFloat = 5.0
let graduationWidth2: CGFloat = 1.0
let digitOffset2: CGFloat = 10

@IBDesignable
class BigClock: UIView
{
    
    var animationTimer: CADisplayLink?
    
    var timezone: NSTimeZone? {
        didSet {
            animationTimer = CADisplayLink(target: self, selector: #selector(ClockView.timerFired(_:)))
            animationTimer?.preferredFramesPerSecond = 8
            animationTimer?.add(to: RunLoop.current, forMode: RunLoopMode.commonModes)
        }
    }
    
    var time: Date?
    var seconds: Int = 0
    var minutes: Int = 0
    var hours: Int = 0
    
    var boundsCenter: CGPoint
    var clockBgColor = UIColor.black
    var borderColor = UIColor.white
    var digitColor = UIColor.white
    var digitFont: UIFont
    
    override init(frame: CGRect)
    {
        digitFont = UIFont()
        boundsCenter = CGPoint()
        super.init(frame: frame)
        let fontSize = 8.0 + frame.size.width/50.0
        digitFont = UIFont.systemFont(ofSize: fontSize)
        boundsCenter = CGPoint(x: bounds.width/2.0, y: bounds.height/2.0)
        self.backgroundColor = UIColor.clear
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        digitFont = UIFont()
        boundsCenter = CGPoint()
        super.init(coder: aDecoder)
        let fontSize = 8.0 + frame.size.width/50.0
        digitFont = UIFont.systemFont(ofSize: fontSize)
        boundsCenter = CGPoint(x: bounds.width/2.0, y: bounds.height/2.0)
        self.backgroundColor = UIColor.clear
    }
    
    func secondsHandPosition() -> CGPoint
    {
        let secondsAsRadians = Float(Double(seconds) / 60.0 * 2.0 * M_PI - M_PI_2)
        let handRadius = CGFloat(frame.size.width / 2.8)
        return CGPoint(x: handRadius*CGFloat(cosf(secondsAsRadians)) + frame.size.width/2.0, y: handRadius*CGFloat(sinf(secondsAsRadians)) + frame.size.height/2.0)
    }
    
    func minutesHandPosition() -> CGPoint
    {
        let minutesAsRadians = Float(Double(minutes) / 60.0 * 2.0 * M_PI - M_PI_2)
        let handRadius = CGFloat(frame.size.width / 3.2)
        return CGPoint(x: handRadius*CGFloat(cosf(minutesAsRadians)) + frame.size.width/2.0, y: handRadius*CGFloat(sinf(minutesAsRadians)) + frame.size.height/2.0)
    }
    
    func hourHandPosition() -> CGPoint
    {
        let halfClock = Double(hours) + Double(minutes) / 60.0
        let hoursAsRadians = Float(halfClock / 12.0 * 2.0 * M_PI - M_PI_2)
        let handRadius = CGFloat(frame.size.width / 4.2)
        return CGPoint(x: handRadius*CGFloat(cosf(hoursAsRadians)) + frame.size.width/2.0, y: handRadius*CGFloat(sinf(hoursAsRadians)) + frame.size.height/2.0)
    }
    
    override func draw(_ rect: CGRect)
    {
        // clock face
        let cxt = UIGraphicsGetCurrentContext()
        cxt?.addEllipse(in: rect)
        cxt?.setFillColor(clockBgColor.cgColor)
        cxt?.fillPath()
        
        // clock's center
        var radius: CGFloat = 6.0
        let center2 = CGRect(x: frame.size.width/2.0 - radius, y: frame.size.height/2.0 - radius, width: 2 * radius, height: 2 * radius)
        cxt?.addEllipse(in: center2)
        cxt?.setFillColor(digitColor.cgColor)
        cxt?.fillPath()
        
        // clock's border
        cxt?.addEllipse(in: CGRect(x: rect.origin.x + borderWidth2/2, y: rect.origin.y + borderWidth2/2, width: rect.size.width - borderWidth2, height: rect.size.height - borderWidth2))
        cxt?.setStrokeColor(borderColor.cgColor)
        cxt?.setLineWidth(borderWidth2)
        cxt?.strokePath()
        
        // numerals
        
        let center = CGPoint(x: rect.size.width / 2.0, y: rect.size.height / 2.0)
        let markingDistanceFromCenter = rect.size.width / 2.0 - digitFont.lineHeight / 4.0 - 15 + digitOffset2
        let offset = 4
        
        for i in 0..<12
        {
            let hourString: String
            if i + 1 < 10
            {
                hourString = " \(i + 1)"
            }
            else
            {
                hourString = "\(i + 1)"
            }
            
            // Swift won't allow all these calculations in one line, so they have to be broken up
            let portion1 = (markingDistanceFromCenter - digitFont.lineHeight / 2.0)
            let portion2 = (M_PI / 180) * Double(i + offset) * 30 + M_PI
            let labelX = center.x + portion1 * CGFloat(cos(portion2))
            
            let portion3 = (M_PI / 180) * Double(i + offset) * 30
            let labelY = center.y - 1 * portion1 * CGFloat(sin(portion3))
            hourString.draw(in: CGRect(x: labelX - digitFont.lineHeight / 2.0, y: labelY - digitFont.lineHeight / 2.0, width: digitFont.lineHeight, height: digitFont.lineHeight), withAttributes: [NSForegroundColorAttributeName: digitColor, NSFontAttributeName: digitFont])
        }
        
        // hands
        
        let minHandPos = minutesHandPosition()
        cxt?.setStrokeColor(digitColor.cgColor)
        cxt?.beginPath()
        //cxt?.move(to: CGPoint(x: <#T##Double#>, y: <#T##Double#>)
        cxt?.move(to: CGPoint(x: frame.size.width/2.0, y: frame.size.height/2.0))
        cxt?.setLineWidth(4.0)
       // cxt?.addLine(to: <#T##CGPoint#>)
        cxt?.addLine(to: CGPoint(x: minHandPos.x, y: minHandPos.y))
        cxt?.strokePath()
        
        let hourHandPos = hourHandPosition()
        cxt?.setStrokeColor(digitColor.cgColor)
        cxt?.beginPath()
        cxt?.move(to: CGPoint(x: frame.size.width/2.0, y: frame.size.height/2.0))
        cxt?.setLineWidth(4.0)
        cxt?.addLine(to: CGPoint(x: hourHandPos.x, y: hourHandPos.y))
        cxt?.strokePath()
        
        let secHandPos = secondsHandPosition()
        cxt?.setStrokeColor(UIColor.red.cgColor)
        cxt?.beginPath()
        cxt?.move(to: CGPoint(x: frame.size.width/2.0, y: frame.size.height/2.0))
        cxt?.setLineWidth(1.0)
        cxt?.addLine(to: CGPoint(x: secHandPos.x, y: secHandPos.y))
        cxt?.strokePath()
        
        // second hand's center
        
        radius = 3.0
        let center3 = CGRect(x: frame.size.width/2.0 - radius, y: frame.size.height/2.0 - radius, width: 2 * radius, height: 2 * radius)
        cxt?.addEllipse(in: center3)
        cxt?.setFillColor(UIColor.red.cgColor)
        cxt?.fillPath()
    }
    
    func timerFired(_ sender: AnyObject)
    {
        time = Date()
        let calendar = NSCalendar(identifier: .gregorian)
        let components = calendar?.components([.hour, .minute, .second], from: time!)
        
        hours = (components?.hour)!
        minutes = (components?.minute)!
        seconds = (components?.second)!
        setNeedsDisplay()
    }
    
    deinit
    {
        animationTimer?.remove(from: RunLoop.current, forMode: RunLoopMode.commonModes)
    }
}
