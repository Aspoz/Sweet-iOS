//
//  LoginViewController.swift
//  namapp
//
//  Created by Jordi Wippert on 03-12-14.
//  Copyright (c) 2014 Jordi Wippert. All rights reserved.
//

import UIKit

class LoginViewController: Backend, UITextFieldDelegate {
    
    @IBOutlet var txtUsername : UITextField!
    @IBOutlet var txtPassword : UITextField!
    
    let backend = Backend()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "background.jpg")!)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func signinTapped(sender : UIButton) {
        var email:NSString = txtUsername.text
        var password:NSString = txtPassword.text
        var user = backend.login(email, password: password)
        if backend.isLoggedIn() {
            self.dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
    func textFieldShouldReturn(textField: UITextField!) -> Bool {   //delegate method
        textField.resignFirstResponder()
        return true
    }
}