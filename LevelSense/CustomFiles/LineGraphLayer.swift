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
    func lineGraphTapped(atLocation point: CGPoint, withIndexs indexes: [Int], inValues:[[CGPoint]])
    func getValueToShowOnXaxisFor(value: Any!) -> Any!
    func getValueToShowOnYaxisFor(value: Any!) -> Any!
}

//MARK: -

//This layer is a single graph layer
class LineGraphChildLayer: CAShapeLayer {

    var lineGraphLayer: LineGraphLayer!
    var values: [CGPoint]!
    var isFilled: Bool = false
    var points: [CGPoint]!
    
    var curvedGraph: Bool = true
    
    class func `init`(lineGraphLayer: LineGraphLayer, values: [CGPoint], stroke:CGColor?, fillColor:CGColor?) -> LineGraphChildLayer {
        
        let lineGraphChildLayer = LineGraphChildLayer()
        lineGraphChildLayer.lineGraphLayer = lineGraphLayer
        lineGraphChildLayer.values = values
        lineGraphChildLayer.strokeColor = stroke != nil ? stroke : UIColor.clear.cgColor
        lineGraphChildLayer.fillColor = fillColor != nil ? fillColor : UIColor.clear.cgColor
        lineGraphChildLayer.isFilled = fillColor != nil
        
        return lineGraphChildLayer
    }
    
    func drawGraph() {
        
        //These two values are added just to make the fillcolor actually color properly
        var newValues: [CGPoint] = [CGPoint]()
        
//        if isFilled {
            newValues.append(CGPoint(x: (values.first?.x)!, y: lineGraphLayer.yValues[0]))
            for i in 0..<values.count {
                newValues.append(values[i])
            }
            newValues.append(CGPoint(x: (values.last?.x)!, y: lineGraphLayer.yValues[0]))
//        }
        
        //Make graph with dots on it
        var newPoints = getPointsForData(values: newValues, xValues: lineGraphLayer.xValues, yValues: lineGraphLayer.yValues, verticalLine: lineGraphLayer.verticalLine, horizontalLine: lineGraphLayer.horizontalLine)
        newPoints = getUpdatedPoints(points: newPoints)
        
        self.points = newPoints
        
        if newPoints.count >= 2 {
            var bezierPath: UIBezierPath!
            
            if curvedGraph {
                bezierPath = UIBezierPath.interpolateCGPoints(withHermite: newPoints, closed: false)
            } else {
                bezierPath = UIBezierPath()
                for i in 0..<newPoints.count {
                    if i == 0 {
                        bezierPath.move(to: newPoints[i])
                    } else {
                        bezierPath.addLine(to: newPoints[i])
                    }
                }
                bezierPath.lineWidth = 1
            }
                        
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
    
    func getUpdatedPoints(points: [CGPoint]) -> [CGPoint] {
        var newPoints = [CGPoint]()
        for i in 0..<points.count {
            newPoints.append(CGPoint.init(x: points[i].x + origin.x, y: self.frame.size.height - (points[i].y + origin.y)))
            
            NSLog("Pointtttttttttttttttt: %@", NSStringFromCGPoint(CGPoint.init(x: points[i].x + origin.x, y: points[i].y + origin.y)))
        }
        return newPoints
    }
    
    func getPointsForData(values: [CGPoint], xValues: [CGFloat], yValues: [CGFloat], verticalLine: VertialLine, horizontalLine: HorizontalLine) -> [CGPoint] {
        
        //Actual variables just check if xMin is set or not. If its set then use it else set the first and last element of xValues and yValues as min and max
        let actualXmin: CGFloat! = lineGraphLayer.xMin == -1 ? xValues[0] : lineGraphLayer.xMin
        let actualXmax: CGFloat! = lineGraphLayer.xMax == -1 ? xValues[0] : lineGraphLayer.xMax
        let actualYmin: CGFloat! = lineGraphLayer.yMin == -1 ? yValues[0] : lineGraphLayer.yMin
        let actualYmax: CGFloat! = lineGraphLayer.yMax == -1 ? yValues[0] : lineGraphLayer.yMax
        
        var points = [CGPoint]()
        
        for i in 0..<values.count {
            let xMultiple = ((values[i].x - actualXmin) / ((actualXmax - xValues[0]) / CGFloat(xValues.count-1)))
            let xPoint = (xMultiple * horizontalLine.oneValueDistance)
            
            let yMultiple = ((values[i].y - actualYmin) / ((actualYmax - yValues[0]) / CGFloat(yValues.count-1)))
            let yPoint = (yMultiple * verticalLine.oneValueDistance)
            
            points.append(CGPoint.init(x: xPoint, y: yPoint))
        }
        
        return points
    }
    
    func getIndexOfValueFor(locationOnLayer: CGPoint) -> Int? {
        let point: CGPoint? = checkIf(point: locationOnLayer, isInRange: 30)
        
        var indexOfValue : Int!
        if point != nil {
            indexOfValue = (self.points as NSArray).index(of: point!)
            
            let isFilledValue: Int = isFilled == true ? 1 : 0
            print("\(indexOfValue - isFilledValue)")
            return indexOfValue - isFilledValue
        } else {
            return nil
        }
    }
    
    func checkIf(point: CGPoint!,isInRange range: CGFloat) -> CGPoint? {
        
        var closestRange: CGFloat = CGFloat(Int.max)
        var resultantPoint: CGPoint?
        
        for i in 0..<self.points.count {
            let distanceBetweenBothPoints = sqrt(pow((self.points[i]).x - (point?.x)!, 2) + pow(self.points[i].y - (point?.y)!, 2))
            //            print("Index: \(i) .... distance: \(distanceBetweenBothPoints)")
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

//This layer contain all the graph(s)
class LineGraphLayer: CAShapeLayer {
    
    var xValues: [CGFloat] = [CGFloat]()
    var yValues: [CGFloat] = [CGFloat]()
    
    var bezierPath: UIBezierPath!
    var lineGraphDelegate: LineGraphProtocol?
    
    var horizontalLine: HorizontalLine!
    var verticalLine: VertialLine!
    
    var childLayers: [LineGraphChildLayer] = [LineGraphChildLayer]()
    
    var xMin : CGFloat! = -1
    var xMax : CGFloat! = -1
    var yMin : CGFloat! = -1
    var yMax : CGFloat! = -1
    
    var isAxisDrawn: Bool = false
    
    class func initWith(parentView: UIView) -> LineGraphLayer {
        let lineGraphLayer = LineGraphLayer()
        
        lineGraphLayer.frame.size = parentView.layer.frame.size
        
        lineGraphLayer.strokeColor = UIColor.clear.cgColor
        lineGraphLayer.fillColor = UIColor.clear.cgColor
        
        parentView.layer.addSublayer(lineGraphLayer)
        
        let tapGesture = UITapGestureRecognizer(target: lineGraphLayer, action: #selector(LineGraphLayer.layerTapped(tapGesture:)))
        parentView.addGestureRecognizer(tapGesture)
        
        return lineGraphLayer
    }
    
    func drawAxisWith(xValues: [CGFloat], yValues: [CGFloat]) {
        
        self.xValues = xValues
        self.yValues = yValues
        
        //Add vertical line and horizontal line
        verticalLine = VertialLine.init(values: yValues as NSArray, size: self.frame.size, origin: origin)
        horizontalLine = HorizontalLine.init(values: xValues as NSArray, size: self.frame.size, origin: origin)
        
        if verticalLine.oneValueDistance > horizontalLine.oneValueDistance {
            verticalLine.oneValueDistance = horizontalLine.oneValueDistance
        } else {
            horizontalLine.oneValueDistance = verticalLine.oneValueDistance
        }
        
        verticalLine.lineGraphDelegate = lineGraphDelegate
        horizontalLine.lineGraphDelegate = lineGraphDelegate
        
        verticalLine.doLayer()
        horizontalLine.doLayer()
        
        self.superlayer?.insertSublayer(verticalLine, at: 0)
        self.superlayer?.insertSublayer(horizontalLine, at: 0)
        
        isAxisDrawn = true
    }
    
    func addLayerWith(stroke:CGColor?, fillColor:CGColor?, values: [CGPoint]) {
        let lineGraphChildLayer: LineGraphChildLayer! = LineGraphChildLayer.init(lineGraphLayer: self, values: values, stroke: stroke, fillColor: fillColor)
        lineGraphChildLayer.frame.size = self.frame.size
        lineGraphChildLayer.drawGraph()
        
        self.childLayers.append(lineGraphChildLayer)
        self.addSublayer(lineGraphChildLayer)
    }
    
    //MARK: Gestures
    
    func layerTapped(tapGesture: UITapGestureRecognizer) {
        let location: CGPoint = tapGesture.location(in: tapGesture.view)
//        let layer: CALayer? = (tapGesture.view?.layer.hitTest(location))
        
        var indexesSelected: [Int?] = [Int?]()
        var values: [[CGPoint]] = []
        for i in 0..<self.childLayers.count {
            let childLayer: LineGraphChildLayer! = self.childLayers[i]
            indexesSelected.append(childLayer.getIndexOfValueFor(locationOnLayer: location))
            values.append(childLayer.values)
        }
        self.lineGraphDelegate?.lineGraphTapped(atLocation: location, withIndexs: indexesSelected as! [Int], inValues: values)
        
    }
    
}

//MARK: -

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
    
    func getWidthOf(text: String) -> CGFloat {
        let label: UILabel! = UILabel()
        label.text = text
        label.font = UIFont.systemFont(ofSize: 5)
        
        return label.intrinsicContentSize.width
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
    var lineGraphDelegate: LineGraphProtocol?
    
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
            
            let text: String = "\(lineGraphDelegate?.getValueToShowOnYaxisFor(value: values![i]) ?? values![i])"
            let decimalPlaces2 : String = CGFloat(Double(text)!).rounded(toPlaces: 2)
            let textLayer = getTextLayerWith(text: decimalPlaces2)
            textLayer.frame = CGRect(x: lineStartX-getWidthOf(text: text)-5, y: yValue-8, width: getWidthOf(text: text), height: 30)
            textLayer.alignmentMode = "right"
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
    var lineGraphDelegate: LineGraphProtocol?
    
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
            
            let text: String = lineGraphDelegate?.getValueToShowOnXaxisFor(value: values![i]) as! String 
            let textLayer = getTextLayerWith(text: "\(text)")
            textLayer.frame = CGRect(x: xValue - self.oneValueDistance/2, y: lineStartY+10, width: self.oneValueDistance, height: 30)
            textLayer.alignmentMode = "center"
            addSublayer(textLayer)
        }
        
        bezierPathAxis.append(bezierPathDots)
        
        strokeColor = UIColor.black.cgColor
        path = bezierPathAxis.cgPath
    }
    
}






