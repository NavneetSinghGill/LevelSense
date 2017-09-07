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

protocol LineGraphProtocol {
    func lineGraphTapped(at point: CGPoint,withIndex index: Int)
}

class LineGraphLayer: CAShapeLayer {
    
    var points : [CGPoint] = [CGPoint]()
    var xValues: NSArray = [Int]() as NSArray
    var yValues: NSArray = [Int]() as NSArray
    
    var bezierPath: UIBezierPath!
    var lineGraphDelegate: LineGraphProtocol?
    var isFilled: Bool = false
    
    
    class func `init`(stroke:CGColor?, fillColor:CGColor?, parentView: UIView) -> LineGraphLayer {
        let lineGraphLayer = LineGraphLayer()
        
        lineGraphLayer.strokeColor = stroke != nil ? stroke : UIColor.clear.cgColor
        lineGraphLayer.fillColor = fillColor != nil ? fillColor : UIColor.clear.cgColor
        lineGraphLayer.frame.size = parentView.layer.frame.size
        lineGraphLayer.isFilled = fillColor != nil
        
        //        lineGraphLayer.setAffineTransform(CGAffineTransform.init(scaleX: 1, y: -1))
        
        parentView.layer.addSublayer(lineGraphLayer)
        
        let tapGesture = UITapGestureRecognizer(target: lineGraphLayer, action: #selector(LineGraphLayer.layerTapped(tapGesture:)))
        parentView.addGestureRecognizer(tapGesture)
        
        return lineGraphLayer
    }
    
    func drawPathWith(points: [CGPoint], xValues: [String], yValues: [String]) {
        
        let newPoints = getUpdatedPoints(points: points)
        
        if newPoints.count >= 2 {
            bezierPath = UIBezierPath.interpolateCGPoints(withHermite: newPoints, closed: false)
            
            let dotsPath = getPathForDotsWith(points: newPoints)
            bezierPath.append(dotsPath)
            
            self.path = bezierPath.cgPath
        } else if (newPoints.count == 1) {
            
        }
        
        self.points = newPoints
        
        let verticalLine = VertialLine.init(values: yValues as NSArray, size: self.frame.size, origin: origin)
        self.superlayer?.insertSublayer(verticalLine, at: 0)
        
        let horizontalLine = HorizontalLine.init(values: xValues as NSArray, size: self.frame.size, origin: origin)
        self.superlayer?.insertSublayer(horizontalLine, at: 0)
    }
    
    func drawPathWith(values: [CGPoint], xValues: [CGFloat], yValues: [CGFloat]) {
        
        //These two values are added just to make the fillcolor actually color properly
        var newValues: [CGPoint] = [CGPoint]()
        
        if isFilled {
            newValues.append(CGPoint(x: (values.first?.x)!, y: 0))
            for i in 0..<values.count {
                newValues.append(values[i])
            }
            newValues.append(CGPoint(x: (values.last?.x)!, y: 0))
        }
        
        
        
        
        //Add vertical line
        let verticalLine = VertialLine.init(values: yValues as NSArray, size: self.frame.size, origin: origin)
        
        //Add horizontal line
        let horizontalLine = HorizontalLine.init(values: xValues as NSArray, size: self.frame.size, origin: origin)
        if verticalLine.oneValueDistance > horizontalLine.oneValueDistance {
            verticalLine.oneValueDistance = horizontalLine.oneValueDistance
        } else {
            horizontalLine.oneValueDistance = verticalLine.oneValueDistance
        }
        
        verticalLine.doLayer()
        horizontalLine.doLayer()
        
        self.superlayer?.insertSublayer(verticalLine, at: 0)
        self.superlayer?.insertSublayer(horizontalLine, at: 0)
        
        //Make graph with dots on it
        var newPoints = getPointsForData(values: newValues, xValues: xValues, yValues: yValues, verticalLine: verticalLine, horizontalLine: horizontalLine)
        newPoints = getUpdatedPoints(points: newPoints)
        
        self.points = newPoints
        
        if newPoints.count >= 2 {
            bezierPath = UIBezierPath.interpolateCGPoints(withHermite: newPoints, closed: false)
            
            let dotsPath = getPathForDotsWith(points: newPoints)
            bezierPath.append(dotsPath)
            
            self.path = bezierPath.cgPath
        } else if (newPoints.count == 1) {
            
        }
        
    }
    
    func getUpdatedPoints(points: [CGPoint]) -> [CGPoint] {
        var newPoints = [CGPoint]()
        for i in 0..<points.count {
            newPoints.append(CGPoint.init(x: points[i].x + origin.x, y: self.frame.size.height - (points[i].y + origin.y)))
            
            NSLog("Pointtttttttttttttttt: %@", NSStringFromCGPoint(CGPoint.init(x: points[i].x + origin.x, y: points[i].y + origin.y)))
        }
        return newPoints
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
        }
        
        return points
    }
    
    //MARK: Gestures
    
    func layerTapped(tapGesture: UITapGestureRecognizer) {
        let location: CGPoint = tapGesture.location(in: tapGesture.view)
//        let layer: CALayer? = (tapGesture.view?.layer.hitTest(location))
        
        let point: CGPoint? = checkIf(point: location, isInRange: 30)
        
        let indexOfValue = (self.points as NSArray).index(of: point!)
        
        let isFilledValue: Int = isFilled == true ? 1 : 0
        self.lineGraphDelegate?.lineGraphTapped(at: location, withIndex: indexOfValue - isFilledValue)
        
        print("\(indexOfValue)")
    }
    
    func checkIf(point: CGPoint!,isInRange range: CGFloat) -> CGPoint? {
        
        var closestRange: CGFloat = CGFloat(Int.max)
        var resultantPoint: CGPoint?
        
        for i in 0..<self.points.count {
            let distanceBetweenBothPoints = sqrt(pow((self.points[i]).x - (point?.x)!, 2) + pow(self.points[i].y - (point?.y)!, 2))
            print("Index: \(i) .... distance: \(distanceBetweenBothPoints)")
            if range > distanceBetweenBothPoints && distanceBetweenBothPoints < closestRange {
                closestRange = distanceBetweenBothPoints
                resultantPoint = self.points[i]
            }
        }
        if closestRange != CGFloat(Int.max) {
            return resultantPoint
        } else {
            return nil
        }
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
    
    var lineStartX: CGFloat!
    var lineStartY: CGFloat!
    var lineEndX: CGFloat!
    var lineEndY: CGFloat!
    
    var values : NSArray?
    
    
    class func `init`(values: NSArray?, size: CGSize, origin: CGPoint) -> VertialLine {
        let layer = VertialLine()
        
        if values?.count != 0 {
            layer.lineStartX = origin.x
            layer.lineStartY = size.height - origin.y
            layer.lineEndX = origin.x
            layer.lineEndY = verticalPadding
            
            let lineDistance = (layer.lineStartY - layer.lineEndY) * percentOfLineWhichShowsData
            let oneValueDistance = lineDistance/CGFloat((values?.count)!-1 >= 1 ? (values?.count)!-1: 1)
            layer.oneValueDistance = oneValueDistance
            layer.values = values
        }
        return layer
    }
    
    func doLayer() {
        let bezierPathAxis = UIBezierPath()
        
        //Create line
        UIColor.black.setStroke()
        bezierPathAxis.stroke()
        bezierPathAxis.move(to: CGPoint.init(x: lineStartX, y: lineStartY))
        bezierPathAxis.addLine(to: CGPoint.init(x: lineEndX, y: lineEndY))
        bezierPathAxis.lineWidth = 2.0
        
        //Create dots
        let bezierPathDots = UIBezierPath()
//        UIColor.blue.setStroke()
//        bezierPathDots.stroke()
        
        for i in 0..<(values?.count)! {
            let yValue = lineStartY - oneValueDistance * CGFloat(i)
            let dotPoint = CGPoint.init(x: lineStartX, y: yValue)
            bezierPathDots.move(to: dotPoint)
            bezierPathDots.addArc(withCenter: dotPoint, radius: 2, startAngle: 0, endAngle: 6, clockwise: true)
            if i == 0 {
                startPoint = dotPoint
            }
            if i == (values?.count)! - 1 {
                endPoint = dotPoint
            }
            
            let textLayer = getTextLayerWith(text: "\(values![i])")
            textLayer.frame = CGRect(x: lineStartX-20, y: yValue-8, width: 30, height: 30)
            addSublayer(textLayer)
        }
        
        bezierPathAxis.append(bezierPathDots)
        
        
        
        
        strokeColor = UIColor.black.cgColor
        path = bezierPathAxis.cgPath
    }
    
}

class HorizontalLine: CustomShapeLayer {
    
    var oneValueDistance: CGFloat!
    var startPoint: CGPoint!
    var endPoint: CGPoint!
    
    var lineStartX: CGFloat!
    var lineStartY: CGFloat!
    var lineEndX: CGFloat!
    var lineEndY: CGFloat!
    
    var values : NSArray?
    
    class func `init`(values: NSArray?, size: CGSize, origin: CGPoint) -> HorizontalLine {
        let layer = HorizontalLine()
        
        if values?.count != 0 {
            
            layer.lineStartX = origin.x
            layer.lineStartY = size.height - origin.y
            layer.lineEndX = size.width - horizontalPadding
            layer.lineEndY = size.height - origin.y
            
            let lineDistance = (layer.lineEndX - layer.lineStartX) * percentOfLineWhichShowsData
            let oneValueDistance = lineDistance/CGFloat((values?.count)! - 1 >= 1 ? (values?.count)! - 1: 1)
            layer.oneValueDistance = oneValueDistance
            layer.values = values
        }
        return layer
    }
    
    func doLayer() {
        let bezierPathAxis = UIBezierPath()
        
        //Create line
        UIColor.black.setStroke()
        bezierPathAxis.stroke()
        bezierPathAxis.move(to: CGPoint.init(x: lineStartX, y: lineStartY))
        bezierPathAxis.addLine(to: CGPoint.init(x: lineEndX, y: lineEndY))
        bezierPathAxis.lineWidth = 2.0
        
        //Create dots
        let bezierPathDots = UIBezierPath()
//        UIColor.blue.setStroke()
//        bezierPathDots.stroke()
        
        for i in 0..<(values?.count)! {
            let xValue = lineStartX + oneValueDistance * CGFloat(i)
            let dotPoint = CGPoint.init(x: xValue, y: lineStartY)
            bezierPathDots.move(to: dotPoint)
            bezierPathDots.addArc(withCenter: dotPoint, radius: 2, startAngle: 0, endAngle: 6, clockwise: true)
            
            if i == 0 {
                startPoint = dotPoint
            }
            if i == (values?.count)! - 1 {
                endPoint = dotPoint
            }
            
            let textLayer = getTextLayerWith(text: "\(values![i])")
            textLayer.frame = CGRect(x: xValue-3, y: lineStartY+10, width: 30, height: 30)
            addSublayer(textLayer)
        }
        
        bezierPathAxis.append(bezierPathDots)
        
        strokeColor = UIColor.black.cgColor
        path = bezierPathAxis.cgPath
    }
    
}






