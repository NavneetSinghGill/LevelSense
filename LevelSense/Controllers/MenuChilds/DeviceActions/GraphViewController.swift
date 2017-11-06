//
//  GraphViewController.swift
//  LevelSense
//
//  Created by Zoeb Sheikh on 9/1/17.
//  Copyright © 2017 Zoeb Sheikh. All rights reserved.
//

import UIKit

class GraphViewController: LSViewController, LineGraphProtocol {
    
    enum TimeStampType {
        case Today
        case Week
    }
    
    let colors: NSArray = [UIColor.green, UIColor.blue, UIColor.orange]
    
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var scrollInnerviewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var popupTrailingConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var popupView: UIView!
    @IBOutlet weak var valueLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBOutlet weak var dateRangeLabel: UILabel!
    
    @IBOutlet weak var timeStampSegmentControl: UISegmentedControl!
    
    var savedToTimeStamp: Int!
    var savedFromTimeStamp: Int!
    
    var allDeviceData: Dictionary<String, Any>!
    var graphViews: [UIView] = []
    var heightOfScrollInnerView: CGFloat = 0
    
    var areGraphsDrawn: Bool = false
    var isPopupOpen: Bool = false
    
    var device: Device?
    var timeStampType: TimeStampType = .Today
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addBackButton()
        setNavigationTitle(title: "Graph")
        setTextForDateLabel(fromTimeStamp: savedFromTimeStamp, toTimeStamp: savedToTimeStamp)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if !areGraphsDrawn {
            readDataAndPlotGraph()
            areGraphsDrawn = true
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        resetUI()
    }
    
    //MARK: Private methods
    
    func readDataAndPlotGraph() {
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
        scrollView.isHidden = count == 0
    }
    
    func resetUI() {
        for graph in graphViews {
            graph.layer.removeSubLayersAndPaths()
        }
        for subview in self.mainView.subviews {
            subview.removeFromSuperview()
        }
        
        mainView.frame.size.height = 0;
        heightOfScrollInnerView = 0;
        
        graphViews.removeAll()
        scrollInnerviewHeightConstraint.constant = 0
        view.layoutIfNeeded()
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
                var pointsCountToPlotX: Int = 5
                var pointsCountToPlotY: Int = 5
                
                if xMax == 1 && xMin == 0 {
                    pointsCountToPlotX = 2
                }
                
                if yMax == 1 && yMin == 0 {
                    pointsCountToPlotY = 2
                }
                
                var xValues : [CGFloat] = [CGFloat]()
                
                let xMaxMinDiff = (xMax - xMin)/CGFloat(pointsCountToPlotX - 1)
                for i in 0..<pointsCountToPlotX {
                    xValues.append(xMin + xMaxMinDiff * CGFloat(i))
                }
                
                var yValues : [CGFloat] = [CGFloat]()
                let yMaxMinDiff = (yMax - yMin)/CGFloat(pointsCountToPlotY - 1)
                for i in 0..<pointsCountToPlotY {
                    yValues.append(yMin + yMaxMinDiff * CGFloat(i))
                }
                lineGraphLayer?.drawAxisWith(xValues: xValues, yValues: yValues, xAxisName: nil, yAxisName: nil)
            }
            
            let graphName = "\(deviceData?["sensorDisplayName"] ?? "")"
            lineGraphLayer?.addLayerWith(stroke: strokeColor, fillColor: fillColor, values: values, graphOf: graphName)
            
            return true
        }
        return false
    }
    
    func showPopupWith(value: CGFloat, andTimeStamp timeStamp: CGFloat, withHorizontalValues:[CGFloat]?, withVerticalValues:[CGFloat]?) {
        popupTrailingConstraint.constant = 5
        UIView.animate(withDuration: 0.5, animations: { 
            self.view.layoutIfNeeded()
        }) { (isComplete) in
            
        }
        
        var valueText: String = ""
        
        if withVerticalValues != nil &&
            withVerticalValues?.count == 2 &&
            withVerticalValues![0] == 0 &&
            withVerticalValues![1] == 1 {
                
            if value == 0 {
                valueText = "OFF"
            } else if value == 1 {
                valueText = "ON"
            } else {
                valueText = "\(value.rounded(toPlaces: 2))"
            }
        } else if withVerticalValues != nil &&
            withVerticalValues!.first == 0 &&
            withVerticalValues!.last == 100 {
            
            valueText = "\(Int(value))%"
        } else {
            valueText = "\(value.rounded(toPlaces: 2))"
        }
        
        
        valueLabel.text = valueText
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
    
    func setDeviceDetails(fromTimeStamp: Int!, toTimeStamp: Int!) {
        
        startAnimating()
        UserRequestManager.postGetDeviceDataListAPICallWith(deviceID: device!.id, limit: 100000, fromTimestamp: fromTimeStamp, toTimestamp: toTimeStamp) { (success, response, error) in
            if success {
                self.resetUI()
                self.allDeviceData = (((response as? Dictionary<String, Any>)!["deviceDataList"]!) as? Dictionary<String,Any>)
                
                self.savedFromTimeStamp = fromTimeStamp
                self.savedToTimeStamp = toTimeStamp
                self.setTextForDateLabel(fromTimeStamp: fromTimeStamp, toTimeStamp: toTimeStamp)
                
                self.readDataAndPlotGraph()
            }
            self.stopAnimating()
        }
    }
    
    func setDeviceDetails(toTimeStamp: Int!) {
        
        let lastDay: Date! = Calendar.current.date(byAdding: getCurrentDateComponent(), value: -1, to: Date(timeIntervalSince1970: Double(toTimeStamp)))
        let fromTimeStamp: Int! = Int(lastDay.timeIntervalSince1970)
        
        setDeviceDetails(fromTimeStamp: fromTimeStamp, toTimeStamp: toTimeStamp)
    }
    
    func setTextForDateLabel(fromTimeStamp: Int!, toTimeStamp: Int!) {
        self.dateRangeLabel.text = "\(getDateFor(timeStamp: CGFloat(fromTimeStamp))) - \(getDateFor(timeStamp: CGFloat(toTimeStamp)))"
    }
    
    func getCurrentDateComponent() -> Calendar.Component {
        switch timeStampType {
        case .Today:
            return .day
        case .Week:
            return .weekOfYear
        }
    }
    
    //MARK: Segment control methods
    
    @IBAction func segmentControlValueChanged(segmentControl: UISegmentedControl) {
        if segmentControl.selectedSegmentIndex == 1 { //Week
            timeStampType = .Week
        } else if segmentControl.selectedSegmentIndex == 0 { //Today
            timeStampType = .Today
        }
        setDeviceDetails(toTimeStamp: savedToTimeStamp)
    }
    
    //MARK: IBAction methods
    
    @IBAction func popupTapped() {
        hidePopup()
    }
    
    @IBAction func leftDateButtonTapped() {
        let toTimestamp: Int! = Int(savedFromTimeStamp)
        let lastMonth: Date! = Calendar.current.date(byAdding: getCurrentDateComponent(), value: -1, to: Date(timeIntervalSince1970: Double(toTimestamp)))
        let fromTimestamp: Int! = Int(lastMonth.timeIntervalSince1970)
        
        setDeviceDetails(fromTimeStamp: fromTimestamp, toTimeStamp: toTimestamp)
    }
    
    @IBAction func rightDateButtonTapped() {
        let fromTimestamp: Int! = Int(savedToTimeStamp)
        let lastMonth: Date! = Calendar.current.date(byAdding: getCurrentDateComponent(), value: 1, to: Date(timeIntervalSince1970: Double(fromTimestamp)))
        let toTimestamp: Int! = Int(lastMonth.timeIntervalSince1970)
        
        setDeviceDetails(fromTimeStamp: fromTimestamp, toTimeStamp: toTimestamp)
    }
    
    //MARK: Line graph layer delegate
    
    func lineGraphTapped(atLocation point: CGPoint, withIndexs indexes: [Int], inValues:[[CGPoint]], withHorizontalValues:[CGFloat]?, withVerticalValues:[CGFloat]?) {
        
        var someValueIsSelected: Bool = false
        for i in 0..<inValues.count {
            let values = inValues[i]
            if indexes[i] != Int.max && indexes[i] < values.count {
                print("\(values[indexes[i]])")
                self.showPopupWith(value: values[indexes[i]].y, andTimeStamp: values[indexes[i]].x, withHorizontalValues: withHorizontalValues, withVerticalValues: withVerticalValues)
                someValueIsSelected = true
            }
        }
        if !someValueIsSelected && isPopupOpen {
            self.timeLabel.text = "----"
            self.valueLabel.text = "----"
        }
    }
    
    func getValueToShowOnXaxisFor(value: Any!, withHorizontalValues: [CGFloat]?) -> Any! {
        return getDateFor(timeStamp: value as! CGFloat)
    }
    
    func getValueToShowOnYaxisFor(value: Any!, withVerticalValues: [CGFloat]?) -> Any! {
        if withVerticalValues != nil &&
            withVerticalValues?.count == 2 &&
            withVerticalValues![0] == 0 &&
            withVerticalValues![1] == 1 {
            
            if value as? Float == 0.0 {
                return "OFF"
            } else if value as? Float == 1.0 {
                return "ON"
            }
        } else if withVerticalValues != nil &&
            withVerticalValues!.first == 0 &&
            withVerticalValues!.last == 100 {
            
            return "\((value as! Int))%"
        }
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
        if timeStampType == .Today {
            dateFormatter.dateFormat = "hh:mm a"
        } else {
            dateFormatter.dateFormat = "d MMM,yy"
        }
        let date: Date = Date.init(timeIntervalSince1970: TimeInterval(timeStamp))
        let dateString: String = dateFormatter.string(from: date)
        
        return dateString
    }
    
}
