//
//  GraphViewController.swift
//  LevelSense
//
//  Created by Zoeb Sheikh on 9/1/17.
//  Copyright © 2017 Zoeb Sheikh. All rights reserved.
//

import UIKit

class GraphViewController: LSViewController, LineGraphProtocol {
    
    @IBOutlet weak var lineChart1: UIView!
    @IBOutlet weak var lineChart2: UIView!
    @IBOutlet weak var lineChart3: UIView!
    
    var lineGraphLayer1: LineGraphLayer?
    var lineGraphLayer2: LineGraphLayer?
    var lineGraphLayer3: LineGraphLayer?
    
    var allDeviceData: Dictionary<String, Any>!
    var path: UIBezierPath!
    
    var months: [String]!
    
    @IBOutlet var lineChart1HeightConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addBackButton()
        setNavigationTitle(title: "Graph")
        
        
        for key in self.allDeviceData.keys {
            
            let deviceData = (allDeviceData[key] as? Dictionary<String, Any>)
            print("\(deviceData?["sensorDisplayName"] ?? "")")
            
            if key == "sensor_2" {
                read(deviceData: deviceData, andShowInView: lineChart3, strokeColor: UIColor.green.cgColor, fillColor: nil, graphHeading: "Temperature")
            } else if key == "sensor_3" {
                read(deviceData: deviceData, andShowInView: lineChart3, strokeColor: UIColor.blue.cgColor, fillColor: nil, graphHeading:  "Humidity")
            } else if key == "sensor_9" {
                read(deviceData: deviceData, andShowInView: lineChart3, strokeColor: UIColor.red.cgColor, fillColor: nil, graphHeading:  "Device runtime")
            }
        }
    }
    
    func read(deviceData: Dictionary<String, Any>?, andShowInView parentView: UIView, strokeColor:CGColor?, fillColor:CGColor?, graphHeading: String) {
        let data = (deviceData?["data"] as? NSArray)
        print("\(String(describing: data?.count))")
        
        var xMin : CGFloat!
        var xMax : CGFloat!
        var yMin : CGFloat!
        var yMax : CGFloat!
        var values: [CGPoint] = [CGPoint]()
        
        for entry in (data as! Array<Dictionary<String, Any>>) {
            values.append(CGPoint(x: CGFloat(entry["timeStamp"] as! Int), y: CGFloat((entry["value"] as! NSString).floatValue)))
        }
        if deviceData?["minTimestamp"] != nil {
            xMin = (deviceData?["minTimestamp"]) as? CGFloat
        }
        if deviceData?["maxTimestamp"] != nil {
            xMax = (deviceData?["maxTimestamp"]) as? CGFloat
        }
        if deviceData?["minValue"] != nil {
            yMin = CGFloat((deviceData?["minValue"] as! NSString).floatValue)
        }
        if deviceData?["maxValue"] != nil {
            yMax = CGFloat((deviceData?["maxValue"] as! NSString).floatValue)
        }
        
        
        //----------------
        if xMin != nil && xMax != nil && yMin != nil && yMax != nil {
            
            if lineGraphLayer3 == nil {
                lineGraphLayer3 = LineGraphLayer.initWith(parentView: lineChart3)
                
                lineGraphLayer3?.lineGraphDelegate = self
                lineGraphLayer3?.xMin = xMin
                lineGraphLayer3?.xMax = xMax
                lineGraphLayer3?.yMin = yMin
                lineGraphLayer3?.yMax = yMax
                
                //Number of points to be shown on the graph on axis
                let pointsCountToPlot: Int = 5
                
                var xValues : [CGFloat] = [CGFloat]()
                
                let xMaxMinDiff = (xMax - xMin)/CGFloat(pointsCountToPlot)
                for i in 0..<pointsCountToPlot {
                    xValues.append(xMin + xMaxMinDiff * CGFloat(i))
                }
                
                var yValues : [CGFloat] = [CGFloat]()
                let yMaxMinDiff = (yMax - yMin)/CGFloat(pointsCountToPlot)
                for i in 0..<pointsCountToPlot {
                    yValues.append(yMin + yMaxMinDiff * CGFloat(i))
                }
                lineGraphLayer3?.drawAxisWith(xValues: xValues, yValues: yValues)
            }
            
            lineGraphLayer3?.addLayerWith(stroke: strokeColor, fillColor: fillColor, values: values, graphOf: graphHeading)
        }
    }
    
    //MARK: Line graph layer delegate
    
    func lineGraphTapped(atLocation point: CGPoint, withIndexs indexes: [Int], inValues: [[CGPoint]]) {
        for i in 0..<inValues.count {
            let values = inValues[i]
            if indexes[i] != Int.max {
                print("\(values[indexes[i]])")
            }
        }
    }
    
    func getValueToShowOnXaxisFor(value: Any!) -> Any! {
        return getDateFor(timeStamp: value as! CGFloat)
    }
    
    func getValueToShowOnYaxisFor(value: Any!) -> Any! {
        return value!
    }
    
    func updatedHeightFor(lineGraphLayer: LineGraphLayer!) {
//        if lineGraphLayer.parentView == lineChart1 {
//            
//        } else if lineGraphLayer.parentView == lineChart2 {
//            
//        } else if lineGraphLayer.parentView == lineChart3 {
            lineChart1HeightConstraint.constant = lineGraphLayer.dynamicHeight
//        }
    }
    
    func getDateFor(timeStamp: CGFloat) -> String {
        let dateFormatter: DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dMMM,YY"
        let date: Date = Date.init(timeIntervalSince1970: TimeInterval(timeStamp*1000))
        let dateString: String = dateFormatter.string(from: date)
        
        return dateString
    }
    
}
