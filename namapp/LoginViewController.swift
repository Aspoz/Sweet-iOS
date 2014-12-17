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
    
    override func viewDidAppear(animated: Bool) {
        if backend.isLoggedIn() {
            self.performSegueWithIdentifier("loginSuccess", sender: self)
            println("this one")
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func signinTapped(sender : UIButton) {
        var email:NSString = txtUsername.text
        var password:NSString = txtPassword.text
        var user = backend.login(email, password: password)
        if backend.isLoggedIn() {
            println("that one")
            self.performSegueWithIdentifier("loginSuccess", sender: self)
        }
    }
    
    func textFieldShouldReturn(textField: UITextField!) -> Bool {   //delegate method
        textField.resignFirstResponder()
        return true
    }
}