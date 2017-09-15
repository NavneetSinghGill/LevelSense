//
//  GraphViewController.swift
//  LevelSense
//
//  Created by Zoeb Sheikh on 9/1/17.
//  Copyright © 2017 Zoeb Sheikh. All rights reserved.
//

import UIKit

class GraphViewController: LSViewController, LineGraphProtocol {
    
    let colors: NSArray = [UIColor.green, UIColor.blue, UIColor.orange, UIColor.brown]
    
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var scrollInnerviewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var popupTrailingConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var popupView: UIView!
    @IBOutlet weak var valueLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    var allDeviceData: Dictionary<String, Any>!
    var graphViews: [UIView] = []
    var heightOfScrollInnerView: CGFloat = 0
    
    var areGraphsDrawn: Bool = false
    var isPopupOpen: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addBackButton()
        setNavigationTitle(title: "Graph")
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if !areGraphsDrawn {
            var count: Int = 0
            for key in self.allDeviceData.keys {
                
                let deviceData = (allDeviceData[key] as? Dictionary<String, Any>)
                print("\(deviceData?["sensorDisplayName"] ?? "")")
                
                let graphView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 20))
                let creationOfLayerSuccessful = createLayerWith(deviceData: deviceData, andShowInView: graphView, strokeColor: (colors.object(at: count%colors.count) as? UIColor)?.cgColor, fillColor: nil)
                
                if creationOfLayerSuccessful {
                    graphView.frame.size.height = (graphView.layer.sublayers?.first?.frame.size.height)!
                    addView(layerView: graphView)
                    
                    if count != 0 {
                        addDividerTo(parentView: graphView)
                    }
                    
                    count += 1
                }
            }
            areGraphsDrawn = true
        }
    }
    
    func addView(layerView: UIView) {
        scrollView.isHidden = false
        
        layerView.frame.origin.y = mainView.frame.size.height
//        mainView.frame.size.height += layerView.frame.size.height
        mainView.addSubview(layerView)
        heightOfScrollInnerView += layerView.frame.size.height
        graphViews.append(layerView)
        
        scrollInnerviewHeightConstraint.constant = heightOfScrollInnerView
        view.layoutIfNeeded()
    }
    
    func addDividerTo(parentView: UIView) {
        let dividerView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: parentView.frame.size.width, height: 1))
        dividerView.backgroundColor = UIColor.black
        parentView.addSubview(dividerView)
    }
    
    func getAGraphView() -> UIView {
        return UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    }
    
    func createLayerWith(deviceData: Dictionary<String, Any>?, andShowInView parentView: UIView, strokeColor:CGColor?, fillColor:CGColor?) -> Bool {
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
        if xMin != nil && xMax != nil && yMin != nil && yMax != nil && xMin != xMax && yMin != yMax {
            var lineGraphLayer: LineGraphLayer!
            if lineGraphLayer == nil {
                lineGraphLayer = LineGraphLayer.initWith(parentView: parentView)
                
                lineGraphLayer?.lineGraphDelegate = self
                lineGraphLayer?.xMin = xMin
                lineGraphLayer?.xMax = xMax
                lineGraphLayer?.yMin = yMin
                lineGraphLayer?.yMax = yMax
                
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
                lineGraphLayer?.drawAxisWith(xValues: xValues, yValues: yValues, xAxisName: "Time-stamp", yAxisName: "Units")
            }
            
            let graphName = "\(deviceData?["sensorDisplayName"] ?? "")"
            lineGraphLayer?.addLayerWith(stroke: strokeColor, fillColor: fillColor, values: values, graphOf: graphName)
            
            return true
        }
        return false
    }
    
    func showPopupWith(value: CGFloat, andTimeStamp timeStamp: CGFloat) {
        popupTrailingConstraint.constant = 5
        UIView.animate(withDuration: 0.5, animations: { 
            self.view.layoutIfNeeded()
        }) { (isComplete) in
            
        }
        valueLabel.text = "\(value)"
        timeLabel.text = getDateFor(timeStamp: timeStamp)
        isPopupOpen = true
    }
    
    func hidePopup() {
        isPopupOpen = false
        popupTrailingConstraint.constant = -self.popupView.frame.size.width
        UIView.animate(withDuration: 0.5, animations: {
            self.view.layoutIfNeeded()
        }) { (isComplete) in
            self.valueLabel.text = "----"
            self.timeLabel.text = "----"
        }
    }
    
    //MARK: IBAction methods
    
    @IBAction func popupTapped() {
        hidePopup()
    }
    
    //MARK: Line graph layer delegate
    
    func lineGraphTapped(atLocation point: CGPoint, withIndexs indexes: [Int], inValues: [[CGPoint]]) {
        var someValueIsSelected: Bool = false
        for i in 0..<inValues.count {
            let values = inValues[i]
            if indexes[i] != Int.max && indexes[i] < values.count {
                print("\(values[indexes[i]])")
                self.showPopupWith(value: values[indexes[i]].y, andTimeStamp: values[indexes[i]].x)
                someValueIsSelected = true
            }
        }
        if !someValueIsSelected && isPopupOpen {
            self.timeLabel.text = "----"
            self.valueLabel.text = "----"
        }
    }
    
    func getValueToShowOnXaxisFor(value: Any!) -> Any! {
        return getDateFor(timeStamp: value as! CGFloat)
    }
    
    func getValueToShowOnYaxisFor(value: Any!) -> Any! {
        return value!
    }
    
    func updatedHeightFor(lineGraphLayer: LineGraphLayer!) {
////        if lineGraphLayer.parentView == lineChart1 {
////            
////        } else if lineGraphLayer.parentView == lineChart2 {
////            
////        } else if lineGraphLayer.parentView == lineChart3 {
//            lineChart1HeightConstraint.constant = lineGraphLayer.dynamicHeight
////        }
    }
    
    func getDateFor(timeStamp: CGFloat) -> String {
        let dateFormatter: DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dMMM,YY"
        let date: Date = Date.init(timeIntervalSince1970: TimeInterval(timeStamp*1000))
        let dateString: String = dateFormatter.string(from: date)
        
        return dateString
    }
    
}
