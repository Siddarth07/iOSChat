//
//  ViewController.swift
//  iOSChat
//
//  Created by Siddarth Kethireddy on 7/20/17.
//  Copyright © 2017 Siddarth Kethireddy. All rights reserved.
//

import UIKit
import Firebase 
import QuartzCore

class ViewController: UIViewController, UITextFieldDelegate {

    //MARK: Variables
    @IBOutlet weak var loginName: UITextField!
    @IBOutlet weak var bottomLayoutConstraint: NSLayoutConstraint!
    @IBOutlet weak var loginButtonVar: UIButton!
    let center = NotificationCenter.default
    
    //MARK: Actions
    @IBAction func loginButton(_ sender: Any) {
        if loginName.text != "" {
            Auth.auth().signInAnonymously(completion: { (user, error) in
                if let error = error {
                    print(error.localizedDescription)
                    return
                }
                //self.performSegue(withIdentifier: "LoginToChat", sender: nil)
            })
        }
        self.performSegue(withIdentifier: "showChannels", sender: nil)
        
    }

    //MARK: View Properties
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        center.addObserver(self, selector: #selector(self.keyboardShowNotification(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        center.addObserver(self, selector: #selector(self.keyboardHideNotification(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardByViewPress()
        self.loginName.delegate = self
        setButtonProperties()
    }
    
    func setButtonProperties() {
        loginName.layer.cornerRadius = 19
        loginButtonVar.layer.cornerRadius = 19;
        loginButtonVar.clipsToBounds = true
    }
    
    //MARK: keyboard properties
    func keyboardShowNotification(_ notification: Notification) {
        let keyboardEndFrame = ((notification as NSNotification).userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let convertedKeyboardEndFrame = view.convert(keyboardEndFrame, from: view.window)
        bottomLayoutConstraint.constant = view.bounds.maxY - convertedKeyboardEndFrame.minY + 15
    }
    
    func keyboardHideNotification(_ notification: Notification) {
        bottomLayoutConstraint.constant = 50
    }
    
    //MARK: Text Field resigns first responder, closes keyboard on done button pressed
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // this will hide the keyboard
        textField.resignFirstResponder()
        return true
    }
    
    deinit {
        center.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        center.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        let navigationVC = segue.destination as! UINavigationController
        let channelVC = navigationVC.viewControllers.first as! ChannelListVC
        channelVC.senderName = loginName?.text
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

