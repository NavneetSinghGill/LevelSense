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
            }
        }
        
        if xMin != nil && xMax != nil && yMin != nil && yMax != nil {
            let lineGraphLayer = LineGraphLayer.initWith(parentView: lineChart)
            
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
            lineGraphLayer.drawAxisWith(xValues: xValues, yValues: yValues)
            lineGraphLayer.addLayerWith(stroke: UIColor.green.cgColor, fillColor: nil, values: values)
        }
    }
    
    //MARK: Line graph layer delegate
    
    func lineGraphTapped(atLocation point: CGPoint, withIndexs indexes: [Int], inValues: [[CGPoint]]) {
        
    }
    
    func getValueToShowOnXaxisFor(value: Any!) -> Any! {
        return getDateFor(timeStamp: value as! CGFloat)
    }
    
    func getValueToShowOnYaxisFor(value: Any!) -> Any! {
        return value!
    }
    
    func getDateFor(timeStamp: CGFloat) -> String {
        let dateFormatter: DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dMMM,YY"
        let date: Date = Date.init(timeIntervalSince1970: TimeInterval(timeStamp*1000))
        let dateString: String = dateFormatter.string(from: date)
        
        return dateString
    }
    
}
