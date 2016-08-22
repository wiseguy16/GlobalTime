//
//  ClockView.swift
//  GlobalTime
//
//  Created by Gregory Weiss on 8/22/16.
//  Copyright © 2016 Gregory Weiss. All rights reserved.
//

import UIKit
import Foundation


let borderWidth: CGFloat = 2
let borderAlpha: CGFloat = 1.0
let graduationOffset: CGFloat = 10
let graduationLength: CGFloat = 5.0
let graduationWidth: CGFloat = 1.0
let digitOffset: CGFloat = 10

@IBDesignable
class ClockView: UIView
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
        let fontSize = 2.0 + frame.size.width/120.0
        digitFont = UIFont.systemFont(ofSize: fontSize)
        boundsCenter = CGPoint(x: bounds.width/2.0, y: bounds.height/2.0)
        self.backgroundColor = UIColor.clear
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        digitFont = UIFont()
        boundsCenter = CGPoint()
        super.init(coder: aDecoder)
        let fontSize = 2.0 + frame.size.width/120.0
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
        cxt?.addEllipse(inRect: rect)
        cxt?.setFillColor(clockBgColor.cgColor)
        cxt?.fillPath()
        
        // clock's center
        var radius: CGFloat = 6.0
        let center2 = CGRect(x: frame.size.width/2.0 - radius, y: frame.size.height/2.0 - radius, width: 2 * radius, height: 2 * radius)
        cxt?.addEllipse(inRect: center2)
        cxt?.setFillColor(digitColor.cgColor)
        cxt?.fillPath()
        
        // clock's border
        cxt?.addEllipse(inRect: CGRect(x: rect.origin.x + borderWidth/2, y: rect.origin.y + borderWidth/2, width: rect.size.width - borderWidth, height: rect.size.height - borderWidth))
        cxt?.setStrokeColor(borderColor.cgColor)
        cxt?.setLineWidth(borderWidth)
        cxt?.strokePath()
        
        // numerals
        
        let center = CGPoint(x: rect.size.width / 2.0, y: rect.size.height / 2.0)
        let markingDistanceFromCenter = rect.size.width / 2.0 - digitFont.lineHeight / 4.0 - 15 + digitOffset
        let offset = 4
        
        for i in 0..<12
        {
            let hourString: NSString
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
        cxt?.moveTo(x: frame.size.width/2.0, y: frame.size.height/2.0)
        cxt?.setLineWidth(4.0)
        cxt?.addLineTo(x: minHandPos.x, y: minHandPos.y)
        cxt?.strokePath()
        
        let hourHandPos = hourHandPosition()
        cxt?.setStrokeColor(digitColor.cgColor)
        cxt?.beginPath()
        cxt?.moveTo(x: frame.size.width/2.0, y: frame.size.height/2.0)
        cxt?.setLineWidth(4.0)
        cxt?.addLineTo(x: hourHandPos.x, y: hourHandPos.y)
        cxt?.strokePath()
        
        let secHandPos = secondsHandPosition()
        cxt?.setStrokeColor(UIColor.red.cgColor)
        cxt?.beginPath()
        cxt?.moveTo(x: frame.size.width/2.0, y: frame.size.height/2.0)
        cxt?.setLineWidth(1.0)
        cxt?.addLineTo(x: secHandPos.x, y: secHandPos.y)
        cxt?.strokePath()
        
        // second hand's center
        
        radius = 3.0
        let center3 = CGRect(x: frame.size.width/2.0 - radius, y: frame.size.height/2.0 - radius, width: 2 * radius, height: 2 * radius)
        cxt?.addEllipse(inRect: center3)
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




/*
@IBDesignable

class ClockView: UIView
{
    
    var animationTimer: CADisplayLink?
    
    var digitFont: UIFont
    var boundsCenter: CGPoint
    var clockBgColor = UIColor.black
    var borderColor = UIColor.white
    var digitColor = UIColor.white
    let borderWidth: CGFloat = 2
    let borderAlpha: CGFloat = 1.0
    
    var time: Date?
    var timezone: NSTimeZone? {
        didSet {
            animationTimer = CADisplayLink(target: self, selector: #selector(ClockView.timerFired(_:)))
            animationTimer?.preferredFramesPerSecond = 8
            animationTimer?.add(to: RunLoop.current, forMode: RunLoopMode.commonModes)
        }
    }
    var seconds = 0
    var minutes = 0
    var hours = 0

    
    override init(frame: CGRect)
    {
        // digitFont = UIFont()
        let fontSize = 8.0 + frame.size.width/50.0
        digitFont = UIFont.systemFont(ofSize: fontSize)
        boundsCenter = CGPoint()
        super.init(frame: frame)
        boundsCenter = CGPoint(x: bounds.width/2.0, y: bounds.height/2.0)
        backgroundColor = UIColor.clear
        
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        
        digitFont = UIFont()
        boundsCenter = CGPoint()
        super.init(coder: aDecoder)
        let fontSize = 8.0 + frame.size.width/50.0
        digitFont = UIFont.systemFont(ofSize: fontSize)
        boundsCenter = CGPoint(x: bounds.width/2.0, y: bounds.height/2.0)
        backgroundColor = UIColor.clear
    }

    override func draw(_ rect: CGRect)
    {
        // Drawing code
        
        if let context = UIGraphicsGetCurrentContext() // Filters out the optional annoying stuff
        {
            // clock face
            context.addEllipse(inRect: rect)
            context.setFillColor(clockBgColor.cgColor)
            context.fillPath()
            
            // clock's center
            var radius: CGFloat = 6.0
            let smallCircle = CGRect(x: boundsCenter.x - radius, y: boundsCenter.y - radius, width: 2 * radius, height: 2 * radius)
            context.addEllipse(inRect: smallCircle)
            context.setFillColor(digitColor.cgColor)
            context.fillPath()
            
            // Clock's border
            let borderRect = CGRect(x: rect.origin.x + borderWidth/2, y: rect.origin.y + borderWidth/2, width: rect.size.width - borderWidth, height: rect.size.height - borderWidth)
            context.addEllipse(inRect: borderRect)
            context.setStrokeColor(borderColor.cgColor)
            context.setLineWidth(borderWidth)
            context.strokePath()
            
            // Hands
            
            
            let minuteHandPosition = minutesHandPosition()
            context.setStrokeColor(digitColor.cgColor)
            context.beginPath()
            context.moveTo(x: boundsCenter.x, y: boundsCenter.y)
            context.setLineWidth(4.0)
            context.addLineTo(x: minuteHandPosition.x, y: minuteHandPosition.y)
            context.strokePath()
            
            let hourHandPosition = hoursHandPosition()
            context.setStrokeColor(digitColor.cgColor)
            context.beginPath()
            context.moveTo(x: boundsCenter.x, y: boundsCenter.y)
            context.setLineWidth(4.0)
            context.addLineTo(x: hourHandPosition.x, y: hourHandPosition.y)
            context.strokePath()
            
            let secondHandPosition = secondsHandPosition()
            context.setStrokeColor(UIColor.red.cgColor)
            context.beginPath()
            context.moveTo(x: boundsCenter.x, y: boundsCenter.y)
            context.setLineWidth(1.0)
            context.addLineTo(x: secondHandPosition.x, y: secondHandPosition.y)
            context.strokePath()
            
            
            // Second hand center
            radius = 3.0
            let reallySmallCircle = CGRect(x: boundsCenter.x - radius, y: boundsCenter.y - radius, width: 2 * radius, height: 2 * radius)
            context.addEllipse(inRect: reallySmallCircle)
            context.setFillColor(UIColor.red.cgColor)
            context.fillPath()
            
            
        }
        
        
        
        
    }
    
    func secondsHandPosition() -> CGPoint
    {
        let secondsAsRadians = Float(Double(seconds) / 60.0 * 2.0 * M_PI - M_PI_2)
        let handradius = CGFloat(frame.size.width / 3.2)
        return CGPoint(x: handradius * CGFloat(cosf(secondsAsRadians)) + boundsCenter.x, y: handradius * CGFloat(sinf(secondsAsRadians)) + boundsCenter.y)
    }
    
    func minutesHandPosition() -> CGPoint
    {
        let minutesAsRadians = Float(Double(minutes) / 60.0 * 2.0 * M_PI - M_PI_2)
        let handradius = CGFloat(frame.size.width / 3.6)
        return CGPoint(x: handradius * CGFloat(cosf(minutesAsRadians)) + boundsCenter.x, y: handradius * CGFloat(sinf(minutesAsRadians)) + boundsCenter.y)
    }
    
    
    func hoursHandPosition() -> CGPoint
    {
        let halfClock = Double(hours) + Double(minutes) / 60.0
        let hoursAsRadians = Float(halfClock / 12.0 * 2.0 * M_PI - M_PI_2)
        let handradius = CGFloat(frame.size.width / 4.2)
        return CGPoint(x: handradius * CGFloat(cosf(hoursAsRadians)) + boundsCenter.x, y: handradius * CGFloat(sinf(hoursAsRadians)) + boundsCenter.y)
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
    
    
    



    

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}

*/
