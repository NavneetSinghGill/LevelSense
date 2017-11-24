//
//  LSViewController.swift
//  LevelSense
//
//  Created by Zoeb Sheikh on 8/18/17.
//  Copyright © 2017 Zoeb Sheikh. All rights reserved.
//


/*
 *
 *
 *      BASE VIEW CONTROLLER
 *
 *
 */

import UIKit
import NVActivityIndicatorView

class LSViewController: UIViewController, NVActivityIndicatorViewable {
    
    var menuBarButton: UIBarButtonItem!
    var backBarButton: UIBarButtonItem!
    var cartBarButton: UIBarButtonItem!
    var navigationTitleLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK:- Public methods
    
    func addMenuButton() {
        if self.revealViewController() != nil && menuBarButton == nil {
            
            menuBarButton = UIBarButtonItem(customView: menuButton())
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
            self.view.addGestureRecognizer(self.revealViewController().tapGestureRecognizer())
            self.navigationItem.leftBarButtonItem = menuBarButton!
            
            self.revealViewController().rearViewRevealWidth = screenWidth - 80 //80 is the width of main screens that will the seen when left menu is open
        }
    }
    
    func addBackButton() {
        if backBarButton == nil {
            backBarButton = UIBarButtonItem(customView: backButton())
            self.navigationItem.leftBarButtonItem = backBarButton!
        }
    }
    
    func addCartButton() {
        if cartBarButton == nil {
            cartBarButton = UIBarButtonItem(customView: cartButton())
            self.navigationItem.rightBarButtonItem = cartBarButton!
        }
    }
    
    func setNavigationTitle(title:String) {
        if (navigationTitleLabel == nil) {
            navigationTitleLabel = UILabel()
        }
        navigationTitleLabel.textColor = blueColor
        navigationTitleLabel.font = UIFont(name: "HelveticaNeue-Bold", size: 16)
        navigationTitleLabel.text = title
        navigationTitleLabel.sizeToFit()
        
        navigationItem.titleView = navigationTitleLabel
    }
    
    func keyboardWillShow(notification: NSNotification) {
        //Overrider this method in derived controllers
    }
    
    func keyboardWillHide(notification: NSNotification) {
        //Overrider this method in derived controllers
    }
    
    func getOptionVCWith(content: NSArray, startIndex: Int?, sender:Any?) -> OptionSelectionViewController {
        let optionVC : OptionSelectionViewController = storyboard?.instantiateViewController(withIdentifier: "OptionSelectionViewController") as! OptionSelectionViewController
        optionVC.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
        optionVC.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        optionVC.delegate = self as! SelectedOptionProtocol
        optionVC.options = content
        optionVC.sender = sender
        optionVC.startIndex = startIndex
        
        return optionVC
    }
    
    //MARK: Private methods
    
    private func menuButton() -> UIButton {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        button.backgroundColor = .clear
        button.setImage(UIImage(named: "menuIcon"), for: .normal)
        button.addTarget(self, action: #selector(revealToggle), for: .touchUpInside)
        
        return button
    }
    
    private func backButton() -> UIButton {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        button.backgroundColor = .clear
        
        var backImage = UIImage(named: "backIcon")
        let templateImage = backImage?.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
        backImage = templateImage
        
        button.setImage(backImage, for: .normal)
        button.imageView?.tintColor = blueColor
        button.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        
        return button
    }
    
    private func cartButton() -> UIButton {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        button.backgroundColor = .clear
        
        var cartImage = UIImage(named: "cart")
        let templateImage = cartImage?.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
        cartImage = templateImage
        
        button.setImage(cartImage, for: .normal)
        button.imageView?.tintColor = blueColor
        button.addTarget(self, action: #selector(cartButtonTapped), for: .touchUpInside)
        
        return button
    }
    
    func revealToggle() {
        view.endEditing(true)
        self.revealViewController().performSelector(onMainThread: #selector(SWRevealViewController.revealToggle(_:)), with: nil, waitUntilDone: false)
    }
    
    func backButtonTapped() {
        if navigationController != nil {
            navigationController?.popViewController(animated: true)
        }
    }
    
    func cartButtonTapped() {
        
    }
    
    //MARK:- IBAction methods
    
//    @IBAction func menuButtonTapped(sender: UIButton) {
//        self.revealViewController().revealToggle(self)
//    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

}
