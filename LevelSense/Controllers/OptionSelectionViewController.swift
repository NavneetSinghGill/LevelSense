//
//  OptionSelectionViewController.swift
//  LevelSense
//
//  Created by Zoeb Sheikh on 8/24/17.
//  Copyright © 2017 Zoeb Sheikh. All rights reserved.
//

import UIKit

protocol SelectedOption {
    func selectedOption(index:NSInteger)
}

class OptionSelectionViewController: LSViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var pickerView: UIPickerView!
    var options: NSArray = [String]() as NSArray
    
    var delegate: SelectedOption!
    var currentIndex: NSInteger = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    //MARK: IBAction methods
    
    @IBAction func cancelButtonTapped() {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func dimissmissButtonTapped() {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func doneButtonTapped() {
        delegate.selectedOption(index: currentIndex)
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
        
        let str = options.object(at: row) as! String
        let font: Dictionary = [ NSFontAttributeName: UIFont(name: "HelveticaNeue", size: 15.0)! ]
        let attString:NSMutableAttributedString = NSMutableAttributedString.init(string: str)
        
        attString.addAttributes([NSForegroundColorAttributeName: blueColor], range: NSMakeRange(0, str.characters.count))
        attString.addAttributes(font, range: NSMakeRange(0, str.characters.count))
        
        return attString
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        currentIndex = row
    }

}
