//
//  GraphViewWindow.swift
//  Calculator
//
//  Created by Stefan Auvergne on 7/20/16.
//  Copyright © 2016 Stefan Auvergne. All rights reserved.
//

import UIKit

class GraphViewWindow: UIView {
    
    var arrayOfYvalues:[Double] = []
    var yMax:Double = 30.0
    var yMin:Double = -30.0
    var xMin:Double = -19.0
    var xMax:Double = 19.0
    var screenHeight:Double = 600.0
    var screenWidth:Double = 380.0
    var xUnit:Double = 38.0
    var yUnit:Double = 60.0
    
    
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        plotFunction()
        drawAxis()
    }
    
    override func layoutSubviews() {
        screenHeight = Double(self.frame.size.height)
        screenWidth = Double(self.frame.size.width)
    }
    
    func drawAxis(){
        let xPath = UIBezierPath()
        UIColor.black.set()
        
        xPath.move(to: CGPoint(x:0, y:300))
        xPath.addLine(to: CGPoint(x:380, y:300))
        xPath.stroke()
        
        //Center at x:190, y:300
        let yPath = UIBezierPath()
        yPath.move(to: CGPoint(x:190, y:0))
        yPath.addLine(to: CGPoint(x:190, y:600))
        yPath.stroke()
        
        let xSpacing = screenWidth/xUnit
        
        for i in Int(xMin)...Int(xMax) {
            //Draw x axis dashes
            
            xPath.move(to: CGPoint(x:190 + Double(i) * xSpacing, y:298))
            xPath.addLine(to: CGPoint(x:190 + Double(i) * xSpacing, y:302))
            xPath.stroke()
            
            //Draw x axis Numbers
            let number = String(i)
            let numberOneRect = CGRect(x: (187 + CGFloat(Double(i) * xSpacing)), y: 303, width: 50, height: 50)
            let font = UIFont(name: "Academy Engraved LET", size: 4)
            let numberOneAttributes = [
                NSFontAttributeName: font!]
            number.draw(in: numberOneRect,
                        withAttributes:numberOneAttributes)
        }
        
        let ySpacing = screenHeight/yUnit
        
        for i in Int(yMin)...Int(yMax){
            //Draw y axis dashes
            yPath.move(to: CGPoint(x:188, y:300 + Double(i) * ySpacing))
            yPath.addLine(to: CGPoint(x:192, y:300 + Double(i) * ySpacing))
            yPath.stroke()
            
            //Draw y axis Numbers
            let number = String(i)
            if i != 0{
                let font = UIFont(name: "Academy Engraved LET", size: 4)
                let numberTwoRect = CGRect(x: 193 , y: 298 + CGFloat(Double(i) * -ySpacing), width: 50, height: 50)
                let numberTwoAttributes = [
                    NSFontAttributeName: font!]
                number.draw(in: numberTwoRect,
                            withAttributes:numberTwoAttributes)
            }
        }
    }
    
    func plotFunction(){
        let scaleY:Double = (yMax - yMin)/screenHeight
        
        let zPath = UIBezierPath()
        UIColor.red.set()
        
        var moveTo:Bool = true
        for i in 0..<arrayOfYvalues.count{
            
            let y = (yMax - arrayOfYvalues[i]) / scaleY
            
            if moveTo{
                zPath.move(to: CGPoint(x:Double(i), y:y))
            }else{
                zPath.addLine(to: CGPoint(x:Double(i), y:y))
                zPath.stroke()
                zPath.lineWidth = 0.5
            }
            if arrayOfYvalues[i] > yMax || arrayOfYvalues[i] < yMin {
                moveTo = true
            }else{
                moveTo = false
            }
        }
    }
}
