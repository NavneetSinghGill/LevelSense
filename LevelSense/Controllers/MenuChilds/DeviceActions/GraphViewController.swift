//
//  GraphViewController.swift
//  LevelSense
//
//  Created by Zoeb Sheikh on 9/1/17.
//  Copyright © 2017 Zoeb Sheikh. All rights reserved.
//

import UIKit

class GraphViewController: LSViewController {
    
    @IBOutlet weak var lineChart: UIView!
    var deviceData: NSArray!
    var path: UIBezierPath!
    
    var months: [String]!

    override func viewDidLoad() {
        super.viewDidLoad()

        addBackButton()
        setNavigationTitle(title: "Graph")
        
        
        var points: [CGPoint] = [CGPoint]()
//        points.append(CGPoint.init(x: 50, y: 50))
//        points.append(CGPoint.init(x: 60, y: 80))
        points.append(CGPoint.init(x: 80, y: 80))
        points.append(CGPoint.init(x: 100, y: 100))
//        points.append(CGPoint.init(x: 100, y: 0))
        
//        points.append(CGPoint.init(x: 0, y: 0))
//        for i in 0..<10 {
//            points.append(CGPoint.init(x: i*10+20, y: Int(arc4random_uniform(100))+50))
//        }
        
        
        let lineGraphLayer = LineGraphLayer.init(stroke: blueColor.cgColor, fillColor: nil, parentLayer: lineChart.layer)
        lineGraphLayer.borderWidth = 1
//        lineGraphLayer.drawPathWith(points: points, xValues: ["0","1","2","3","4","5","6"], yValues: ["0","1","2","3","4","5"])
        lineGraphLayer.drawPathWith(values: [CGPoint.init(x: 0, y: 0),CGPoint.init(x: 1, y: 1),CGPoint.init(x: 5, y: 2),CGPoint.init(x: 8, y: 5),CGPoint.init(x: 9, y: 9)], xValues: [0,1,2,3,4,5,6,7,8,9], yValues: [0,1,2,3,4,5,6,7,8,9])
        
        
//        draw(points: points)    
    }
    
    func draw(points: [CGPoint]) {
        
        let shapeLayer = drawLineGraphFor(points: points)
        
        shapeLayer.path = self.path.cgPath
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = UIColor.black.cgColor
        shapeLayer.lineWidth = 3.0
        
        self.lineChart.layer.addSublayer(shapeLayer)
        
        for i in 0..<points.count {
            addDotAt(point: points[i], inLayer: self.lineChart.layer)
        }
    }

    func drawLineGraphFor(points: [CGPoint]) -> CAShapeLayer {
        let shapeLayer = CAShapeLayer()
        
        path = UIBezierPath.interpolateCGPoints(withHermite: points, closed: false)
        
        return shapeLayer
    }
 
    func addDotAt(point:CGPoint, inLayer: CALayer) {
        let shapelayer = CAShapeLayer()
        shapelayer.strokeColor = UIColor.blue.cgColor
        shapelayer.path = UIBezierPath(arcCenter: point, radius: 2, startAngle: 0, endAngle: 6, clockwise: true).cgPath
        inLayer.addSublayer(shapelayer)
    }
    
    
}
