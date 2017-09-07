//
//  GraphViewController.swift
//  LevelSense
//
//  Created by Zoeb Sheikh on 9/1/17.
//  Copyright © 2017 Zoeb Sheikh. All rights reserved.
//

import UIKit

class GraphViewController: LSViewController, LineGraphProtocol {
    
    @IBOutlet weak var lineChart: UIView!
    var allDeviceData: Dictionary<String, Any>!
    var path: UIBezierPath!
    
    var months: [String]!

    override func viewDidLoad() {
        super.viewDidLoad()

        addBackButton()
        setNavigationTitle(title: "Graph")
        
        var values: [CGPoint] = [CGPoint]()
        
        var xMin : CGFloat!
        var xMax : CGFloat!
        var yMin : CGFloat!
        var yMax : CGFloat!
        
        for key in self.allDeviceData.keys {
            if key == "sensor_2" {
                let deviceData = (allDeviceData[key] as? Dictionary<String, Any>)
                print("\(deviceData?["sensorDisplayName"] ?? "")")
                
                let data = (deviceData?["data"] as? NSArray)
                print("\(data?.count)")
                
                for entry in (data as! Array<Dictionary<String, Any>>) {
                    values.append(CGPoint(x: CGFloat(entry["timeStamp"] as! Int), y: CGFloat((entry["value"] as! NSString).floatValue)))
                }
                xMin = (deviceData?["minTimestamp"]!) as! CGFloat
                xMax = (deviceData?["maxTimestamp"]!) as! CGFloat
                yMin = CGFloat((deviceData?["minValue"] as! NSString).floatValue)
                yMax = CGFloat((deviceData?["maxValue"] as! NSString).floatValue)
            }
        }
        
        let lineGraphLayer = LineGraphLayer.init(stroke: blueColor.cgColor, fillColor: onlineGreen.cgColor, parentView: lineChart)
        
        lineGraphLayer.lineGraphDelegate = self
        lineGraphLayer.xMin = xMin
        lineGraphLayer.xMax = xMax
        lineGraphLayer.yMin = yMin
        lineGraphLayer.yMax = yMax
        
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
        
        lineGraphLayer.drawPathWith(values: values, xValues: xValues, yValues: yValues)
        
        
    }
    
    //MARK: Line graph layer delegate
    
    func lineGraphTapped(at point: CGPoint,withIndex index: Int) {
        
    }
    
    func getValueToShowOnXaxisFor(value: Any!) -> Any! {
        return getDateFor(timeStamp: value as! CGFloat)
    }
    
    func getValueToShowOnYaxisFor(value: Any!) -> Any! {
        return value!
    }
    
    func getDateFor(timeStamp: CGFloat) -> String {
        let dateFormatter: DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM dd"
        let date: Date = Date.init(timeIntervalSince1970: TimeInterval(timeStamp*1000))
        let dateString: String = dateFormatter.string(from: date)
        
        return dateString
    }
    
}
