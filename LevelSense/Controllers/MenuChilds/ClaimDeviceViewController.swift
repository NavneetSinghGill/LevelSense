//
//  ClaimDeviceViewController.swift
//  LevelSense
//
//  Created by Zoeb Sheikh on 8/23/17.
//  Copyright © 2017 Zoeb Sheikh. All rights reserved.
//

import UIKit

class ClaimDeviceViewController: LSViewController, SelectedOptionProtocol {
    
    let defaultCodeValue = "----"
    let codeColorNames: NSArray = ["Red","White","Yellow","Green","Blue","Purple"]
    let codeColors: NSArray = [offlineRed,
                               UIColor.lightGray,
                               UIColor.init(red: 210/255, green: 210/255, blue: 0, alpha: 1),
                               onlineGreen,
                               UIColor.blue,
                               UIColor.purple]
    
    @IBOutlet weak var powerButton: UIButton!
    @IBOutlet weak var cloudButton: UIButton!
    @IBOutlet weak var calibrateButton: UIButton!
    @IBOutlet weak var alarmButton: UIButton!
    
    @IBOutlet weak var powerLabel: UILabel!
    @IBOutlet weak var cloudLabel: UILabel!
    @IBOutlet weak var calibrateLabel: UILabel!
    @IBOutlet weak var alarmLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        addMenuButton()
        setNavigationTitle(title: "CLAIM DEVICES")
    }

    //MARK: IBAction methods
    
    @IBAction func powerButtonTapped() {
        let optionVC : OptionSelectionViewController = getOptionVCWith(sender: powerButton)
        optionVC.startIndex = codeColorNames.index(of: powerLabel.text!)
        self.present(optionVC, animated: true, completion: nil)
    }
    
    @IBAction func cloudButtonTapped() {
        let optionVC : OptionSelectionViewController = getOptionVCWith(sender: cloudButton)
        optionVC.startIndex = codeColorNames.index(of: cloudLabel.text!)
        self.present(optionVC, animated: true, completion: nil)
    }
    
    @IBAction func calibrateButtonTapped() {
        let optionVC : OptionSelectionViewController = getOptionVCWith(sender: calibrateButton)
        optionVC.startIndex = codeColorNames.index(of: calibrateLabel.text!)
        self.present(optionVC, animated: true, completion: nil)
    }
    
    @IBAction func alarmButtonTapped() {
        let optionVC : OptionSelectionViewController = getOptionVCWith(sender: alarmButton)
        optionVC.startIndex = codeColorNames.index(of: alarmLabel.text!)
        self.present(optionVC, animated: true, completion: nil)
    }
    
    @IBAction func claimDeviceButtonTapped() {
        postClaimDevice()
    }
    
    //MARK: Private methods
    
    private func getOptionVCWith(sender:Any?) -> OptionSelectionViewController {
        let optionVC : OptionSelectionViewController = storyboard?.instantiateViewController(withIdentifier: "OptionSelectionViewController") as! OptionSelectionViewController
        optionVC.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
        optionVC.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        optionVC.delegate = self;
        optionVC.options = codeColorNames
        optionVC.sender = sender
        
        return optionVC
    }
    
    private func areEntryCodesValid() -> Bool {
        if powerLabel.text == defaultCodeValue || cloudLabel.text == defaultCodeValue || calibrateLabel.text == defaultCodeValue || alarmLabel.text == defaultCodeValue {
            Banner.showFailureWithTitle(title: "Please set all the color codes first")
            return false
        }
        return true
    }
    
    func codeForText(text: String) -> Int {
        return codeColorNames.index(of: text) + 1
    }
    
    private func postClaimDevice() {
        if areEntryCodesValid() {
            let codes: NSArray = [ codeForText(text: powerLabel.text!),
                                  codeForText(text: cloudLabel.text!),
                                  codeForText(text: calibrateLabel.text!),
                                  codeForText(text: alarmLabel.text!)]
            UserRequestManager.postClaimDeviceAPICallWith(codes: codes, block: { (success, response, error) in
                if success {
                    
                }
            })
        }
    }
    
    //MARK:- selectedOption protocol method
    
    func selectedOption(index: NSInteger, sender: Any?) {
        let attributedString : NSAttributedString! = getAttributedStringForIndex(index: index)
        
        let button = sender as? UIButton
        
        if button == powerButton {
            powerLabel.attributedText = attributedString
        } else if button == cloudButton {
            cloudLabel.attributedText = attributedString
        } else if button == calibrateButton {
            calibrateLabel.attributedText = attributedString
        } else if button == alarmButton {
            alarmLabel.attributedText = attributedString
        }
    }
    
    func attributedString(index:NSInteger, sender: Any?) -> NSAttributedString {
        
        let attString: NSAttributedString = getAttributedStringForIndex(index: index)
        
        return attString
    }
    
    func getAttributedStringForIndex(index: Int) -> NSAttributedString {
        var str: String! = codeColorNames[index] as! String
        let color : UIColor! = codeColors[index] as! UIColor
        
        let attString:NSMutableAttributedString = NSMutableAttributedString.init(string: str)
        
        attString.addAttributes([NSForegroundColorAttributeName: color], range: NSMakeRange(0, str.characters.count))
        
        return attString
    }
    
}
