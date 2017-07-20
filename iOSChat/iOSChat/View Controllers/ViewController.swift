//
//  ViewController.swift
//  iOSChat
//
//  Created by Siddarth Kethireddy on 7/20/17.
//  Copyright © 2017 Siddarth Kethireddy. All rights reserved.
//

import UIKit
import Firebase 

class ViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var loginName: UITextField!
    @IBOutlet weak var bottomLayoutConstraint: NSLayoutConstraint!
    @IBAction func loginButton(_ sender: Any) {
    }
    let center = NotificationCenter.default
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        center.addObserver(self, selector: #selector(self.keyboardShowNotification(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        center.addObserver(self, selector: #selector(self.keyboardHideNotification(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardByViewPress()
        self.loginName.delegate = self
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func keyboardShowNotification(_ notification: Notification) {
        let keyboardEndFrame = ((notification as NSNotification).userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let convertedKeyboardEndFrame = view.convert(keyboardEndFrame, from: view.window)
        bottomLayoutConstraint.constant = view.bounds.maxY - convertedKeyboardEndFrame.minY
    }
    
    func keyboardHideNotification(_ notification: Notification) {
        bottomLayoutConstraint.constant = 50
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // this will hide the keyboard
        textField.resignFirstResponder()
        return true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit {
        center.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        center.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
}

extension UIViewController {
    func hideKeyboardByViewPress() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    func dismissKeyboard() {
        view.endEditing(true)
    }
}

