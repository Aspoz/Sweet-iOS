//
//  Backend.swift
//  namapp
//
//  Created by Jordi Wippert on 15-12-14.
//  Copyright (c) 2014 Jordi Wippert. All rights reserved.
//

import Foundation
import UIKit

class Backend : UIViewController {
    
    let BASE_URL = "http://0.0.0.0:3000"
    var jsonData: NSDictionary!
    
    func endpoint_url(param: String) -> NSURL{
        var string_url = BASE_URL + param
        var url:NSURL = NSURL(string: string_url)!
        return url
    }
    
    func post(endpoint: String, params: String) -> NSDictionary {
        var postData:NSData = params.dataUsingEncoding(NSUTF8StringEncoding)!
        var url:NSURL = endpoint_url(endpoint)
        var request:NSMutableURLRequest = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "POST"
        request.HTTPBody = postData
        var reponseError: NSError?
        var response: NSURLResponse?
        var urlData: NSData? = NSURLConnection.sendSynchronousRequest(request, returningResponse:&response, error:&reponseError)
        var error: NSError?
        let jsonData:NSDictionary = NSJSONSerialization.JSONObjectWithData(urlData!, options:NSJSONReadingOptions.MutableContainers , error: &error) as NSDictionary
        return jsonData
    }
    
    func login(email: String, password: String) -> NSDictionary {
        var params = "email=\(email)&password=\(password)"
        var user = Backend().post("/sessions", params: params)
        var success:Bool = user.valueForKey("success") as Bool
        if success {
            createUserDefaults(email, password: password, user: user)
        } else {
            var error:NSArray = user.valueForKey("errors") as NSArray
            var message:String = error[0] as String
            alert("Login error", message: message)
        }
        return user
    }
    
    func createUserDefaults(email: String, password: String, user: NSDictionary) -> Bool {
        var prefs:NSUserDefaults = NSUserDefaults.standardUserDefaults()
        prefs.setObject(email, forKey: "username")
        prefs.setObject(user.valueForKey("user_id"), forKey: "userid")
        prefs.setBool(true, forKey: "isloggedin")
        prefs.synchronize()
        return true
    }
    
    func isLoggedIn() -> Bool {
        let prefs:NSUserDefaults = NSUserDefaults.standardUserDefaults()
        var isLoggedIn:Bool = prefs.boolForKey("isloggedin") as Bool
        return isLoggedIn
    }
    
    func alert(title: String, message: String, button: String = "OK") -> UIAlertView {
        var alertView:UIAlertView = UIAlertView()
        alertView.title = title
        alertView.message = message
        alertView.delegate = self
        alertView.addButtonWithTitle(button)
        alertView.show()
        return alertView
    }
}
