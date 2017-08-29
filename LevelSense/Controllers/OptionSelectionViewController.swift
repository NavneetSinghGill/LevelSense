//
//  OptionSelectionViewController.swift
//  LevelSense
//
//  Created by Zoeb Sheikh on 8/24/17.
//  Copyright © 2017 Zoeb Sheikh. All rights reserved.
//

import UIKit

@objc protocol SelectedOptionProtocol {
    
    @objc optional func selectedOption(index:NSInteger, sender: Any?)
    @objc optional func attributedString(index:NSInteger, sender: Any?) -> NSAttributedString
}

class OptionSelectionViewController: LSViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var pickerView: UIPickerView!
    var options: NSArray = [String]() as NSArray
    
    var delegate: SelectedOptionProtocol!
    var currentIndex: NSInteger = 0
    var startIndex: Int! = 0
    
    var sender: Any?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        pickerView.reloadAllComponents()
        if startIndex < options.count {
            pickerView.selectRow(startIndex, inComponent: 0, animated: false)
            currentIndex = startIndex
        }
    }
    
    //MARK: IBAction methods
    
    @IBAction func cancelButtonTapped() {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func dimissmissButtonTapped() {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func doneButtonTapped() {
        delegate.selectedOption!(index: currentIndex, sender: sender)
        dismiss(animated: true, completion: nil)
    }
    
    //MARK: Picker methods
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return options.count
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        
        let attString = delegate?.attributedString?(index: row, sender: sender)
        
        if attString != nil {
            return attString
        } else {
            
            let str = options.object(at: row) as! String
            let font: Dictionary = [ NSFontAttributeName: UIFont(name: "HelveticaNeue", size: 15.0)! ]
            let attString:NSMutableAttributedString = NSMutableAttributedString.init(string: str)
            
            attString.addAttributes([NSForegroundColorAttributeName: blueColor], range: NSMakeRange(0, str.characters.count))
            attString.addAttributes(font, range: NSMakeRange(0, str.characters.count))
            
            return attString
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        currentIndex = row
    }

}
