//
//  LineGraph.swift
//  LevelSense
//
//  Created by Zoeb Sheikh on 9/4/17.
//  Copyright © 2017 Zoeb Sheikh. All rights reserved.
//

import UIKit

let verticalPadding: CGFloat = 30.0
let horizontalPadding: CGFloat = 30.0
let origin: CGPoint = CGPoint.init(x: 40, y: 40)
let percentOfLineWhichShowsData: CGFloat = 0.9

class LineGraphLayer: CAShapeLayer {
    
    var points: NSArray = [CGPoint]() as NSArray
    var xValues: NSArray = [Int]() as NSArray
    var yValues: NSArray = [Int]() as NSArray
    
    var bezierPath: UIBezierPath!

    func getUpdatedPoints(points: [CGPoint]) -> [CGPoint] {
        var newPoints = [CGPoint]()
        for i in 0..<points.count {
            newPoints.append(CGPoint.init(x: points[i].x + origin.x, y: points[i].y + origin.y))
        }
        return newPoints
    }
    
    func drawPathWith(points: [CGPoint], xValues: [String], yValues: [String]) {
        
        let newPoints = getUpdatedPoints(points: points)
        
        bezierPath = UIBezierPath.interpolateCGPoints(withHermite: newPoints, closed: false)
        self.path = bezierPath.cgPath
        
        
        let verticalLine = VertialLine.init(values: yValues as NSArray, size: self.frame.size, origin: origin)
        self.superlayer?.addSublayer(verticalLine)
        
        let horizontalLine = HorizontalLine.init(values: xValues as NSArray, size: self.frame.size, origin: origin)
        self.superlayer?.addSublayer(horizontalLine)
    }
    
    func drawPathWith(values: [CGPoint], xValues: [CGFloat], yValues: [CGFloat]) {
        
        let verticalLine = VertialLine.init(values: yValues as NSArray, size: self.frame.size, origin: origin)
        self.superlayer?.addSublayer(verticalLine)
        
        let horizontalLine = HorizontalLine.init(values: xValues as NSArray, size: self.frame.size, origin: origin)
        self.superlayer?.addSublayer(horizontalLine)
        
        var newPoints = getPointsForData(values: values, xValues: xValues, yValues: yValues, verticalLine: verticalLine, horizontalLine: horizontalLine)
        newPoints = getUpdatedPoints(points: newPoints)
        
        if newPoints.count >= 2 {
            bezierPath = UIBezierPath.interpolateCGPoints(withHermite: newPoints, closed: false)
            
            let dotsPath = getPathForDotsWith(points: newPoints)
            bezierPath.append(dotsPath)
            
            self.path = bezierPath.cgPath
        } else if (newPoints.count == 1) {
            
        }
        
    }
    
    func getPathForDotsWith(points: [CGPoint]) -> UIBezierPath {
        let bezierPathDots = UIBezierPath()
        
        for i in 0..<points.count {
            let dotPoint = CGPoint.init(x: points[i].x, y: points[i].y)
            bezierPathDots.move(to: dotPoint)
            bezierPathDots.addArc(withCenter: dotPoint, radius: 2, startAngle: 0, endAngle: 6, clockwise: true)
        }
        
        return bezierPathDots
    }
    
    func getPointsForData(values: [CGPoint], xValues: [CGFloat], yValues: [CGFloat], verticalLine: VertialLine, horizontalLine: HorizontalLine) -> [CGPoint] {
        var points = [CGPoint]()
        
        for i in 0..<values.count {
            let xMultiple = ((values[i].x - xValues[0]) / ((xValues[xValues.count - 1] - xValues[0]) / CGFloat(xValues.count-1)))
            let xPoint = (xMultiple * horizontalLine.oneValueDistance)
            
            let yMultiple = ((values[i].y - yValues[0]) / ((yValues[yValues.count - 1] - yValues[0]) / CGFloat(yValues.count-1)))
            let yPoint = (yMultiple * verticalLine.oneValueDistance)
            
            points.append(CGPoint.init(x: xPoint, y: yPoint))
            
            NSLog("Pointtttttttttttttttt: %@", NSStringFromCGPoint(CGPoint.init(x: xPoint, y: yPoint)))
        }
        
        return points
    }
    
    class func `init`(stroke:CGColor?, fillColor:CGColor?, parentLayer: CALayer) -> LineGraphLayer {
        let lineGraphLayer = LineGraphLayer()
        
        lineGraphLayer.strokeColor = stroke != nil ? stroke : UIColor.clear.cgColor
        lineGraphLayer.fillColor = fillColor != nil ? fillColor : UIColor.clear.cgColor
        lineGraphLayer.frame.size = parentLayer.frame.size
        
        lineGraphLayer.setAffineTransform(CGAffineTransform.init(scaleX: 1, y: -1))
        
        parentLayer.addSublayer(lineGraphLayer)
        
        return lineGraphLayer
    }
    
}

class CustomShapeLayer: CAShapeLayer {
    
    func getTextLayerWith(text: String) -> CATextLayer {
        let label = CATextLayer()
//        label.font = UIFont(name: "Helvetica", size: 5)
//        label.contentsScale =  UIScreen.main.scale
        label.font = 5 as CFTypeRef
        label.foregroundColor = UIColor.black.cgColor
        label.string = text
        
        return label
    }
    
}

class VertialLine: CustomShapeLayer {
    
    var oneValueDistance: CGFloat!
    var startPoint: CGPoint!
    var endPoint: CGPoint!
    
    class func `init`(values: NSArray?, size: CGSize, origin: CGPoint) -> VertialLine {
        let layer = VertialLine()
        
        if values?.count != 0 {
            let bezierPathAxis = UIBezierPath()
            
            let startPointX = origin.x
            let startPointY = size.height - origin.y
            let endPointX = origin.x
            let endPointY = verticalPadding
            
            let lineDistance = (startPointY - endPointY) * percentOfLineWhichShowsData
            let oneValueDistance = lineDistance/CGFloat((values?.count)!-1 >= 1 ? (values?.count)!-1: 1)
            layer.oneValueDistance = oneValueDistance
            
            //Create line
            UIColor.black.setStroke()
            bezierPathAxis.stroke()
            bezierPathAxis.move(to: CGPoint.init(x: startPointX, y: startPointY))
            bezierPathAxis.addLine(to: CGPoint.init(x: endPointX, y: endPointY))
            bezierPathAxis.lineWidth = 2.0
            
            //Create dots
            let bezierPathDots = UIBezierPath()
            UIColor.blue.setStroke()
            bezierPathDots.stroke()
            
            for i in 0..<(values?.count)! {
                let yValue = startPointY - oneValueDistance * CGFloat(i)
                let dotPoint = CGPoint.init(x: startPointX, y: yValue)
                bezierPathDots.move(to: dotPoint)
                bezierPathDots.addArc(withCenter: dotPoint, radius: 2, startAngle: 0, endAngle: 6, clockwise: true)
                if i == 0 {
                    layer.startPoint = dotPoint
                }
                if i == (values?.count)! - 1 {
                    layer.endPoint = dotPoint
                }
                
                let textLayer = layer.getTextLayerWith(text: "\(values![i])")
                textLayer.frame = CGRect(x: startPointX-20, y: yValue-8, width: 30, height: 30)
                layer.addSublayer(textLayer)
            }
            
            bezierPathAxis.append(bezierPathDots)
            
            
            
            
            layer.strokeColor = UIColor.black.cgColor
            layer.path = bezierPathAxis.cgPath
        }
        return layer
    }
    
}

class HorizontalLine: CustomShapeLayer {
    
    var oneValueDistance: CGFloat!
    var startPoint: CGPoint!
    var endPoint: CGPoint!
    
    class func `init`(values: NSArray?, size: CGSize, origin: CGPoint) -> HorizontalLine {
        let layer = HorizontalLine()
        
        if values?.count != 0 {
            
            let bezierPathAxis = UIBezierPath()
            
            let startPointX = origin.x
            let startPointY = size.height - origin.y
            let endPointX = size.width - horizontalPadding
            let endPointY = size.height - origin.y
            
            let lineDistance = (endPointX - startPointX) * percentOfLineWhichShowsData
            let oneValueDistance = lineDistance/CGFloat((values?.count)! - 1 >= 1 ? (values?.count)! - 1: 1)
            layer.oneValueDistance = oneValueDistance
            
            //Create line
            UIColor.black.setStroke()
            bezierPathAxis.stroke()
            bezierPathAxis.move(to: CGPoint.init(x: startPointX, y: startPointY))
            bezierPathAxis.addLine(to: CGPoint.init(x: endPointX, y: endPointY))
            bezierPathAxis.lineWidth = 2.0
            
            //Create dots
            let bezierPathDots = UIBezierPath()
            UIColor.blue.setStroke()
            bezierPathDots.stroke()
            
            for i in 0..<(values?.count)! {
                let xValue = startPointX + oneValueDistance * CGFloat(i)
                let dotPoint = CGPoint.init(x: xValue, y: startPointY)
                bezierPathDots.move(to: dotPoint)
                bezierPathDots.addArc(withCenter: dotPoint, radius: 2, startAngle: 0, endAngle: 6, clockwise: true)
                
                if i == 0 {
                    layer.startPoint = dotPoint
                }
                if i == (values?.count)! - 1 {
                    layer.endPoint = dotPoint
                }
                
                let textLayer = layer.getTextLayerWith(text: "\(values![i])")
                textLayer.frame = CGRect(x: xValue-3, y: startPointY+10, width: 30, height: 30)
                layer.addSublayer(textLayer)
            }
            
            bezierPathAxis.append(bezierPathDots)
            
            layer.strokeColor = UIColor.black.cgColor
            layer.path = bezierPathAxis.cgPath
        }
        return layer
    }
    
}






