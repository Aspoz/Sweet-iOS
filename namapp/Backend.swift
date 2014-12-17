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
    
    let BASE_URL = "http://178.62.204.157"
    
    func endpoint_url(param: String) -> NSURL{
        var string_url = BASE_URL + param
        var url:NSURL = NSURL(string: string_url)!
        return url
    }
    
    func post(endpoint: String, params: String) -> NSDictionary {
        var postData:NSData = params.dataUsingEncoding(NSUTF8StringEncoding)!
        var url:NSURL = endpoint_url(endpoint)
        var request:NSMutableURLRequest = NSMutableURLRequest(URL: url)
        var token = userToken()
        request.setValue("Token token=\(token)", forHTTPHeaderField: "Authorization")
        request.HTTPMethod = "POST"
        request.HTTPBody = postData
        var reponseError: NSError?
        var response: NSURLResponse?
        var urlData: NSData? = NSURLConnection.sendSynchronousRequest(request, returningResponse:&response, error:&reponseError)
        var error: NSError?
        let jsonData:NSDictionary = NSJSONSerialization.JSONObjectWithData(urlData!, options:NSJSONReadingOptions.MutableContainers, error: &error) as NSDictionary
        return jsonData
    }
    
    func destroy(endpoint: String) {
        var url:NSURL = endpoint_url(endpoint)
        var request:NSMutableURLRequest = NSMutableURLRequest(URL: url)
        var token = userToken()
        request.setValue("Token token=\(token)", forHTTPHeaderField: "Authorization")
        var user_id = currentUser()
        var params = "user_id=\(user_id)&_method=DELETE"
        var postData:NSData = params.dataUsingEncoding(NSUTF8StringEncoding)!
        request.HTTPBody = postData
        request.HTTPMethod = "POST"
        var reponseError: NSError?
        var response: NSURLResponse?
        var urlData: NSData? = NSURLConnection.sendSynchronousRequest(request, returningResponse:&response, error:&reponseError)
    }
    
    func login(email: String, password: String) -> NSDictionary {
        var user = Backend().post("/sessions", params: "email=\(email)&password=\(password)")
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
        prefs.setObject(user.valueForKey("access_token"), forKey: "access_token")
        prefs.setBool(true, forKey: "isloggedin")
        prefs.synchronize()
        return true
    }

    func isLoggedIn() -> Bool {
        let prefs:NSUserDefaults = NSUserDefaults.standardUserDefaults()
        var isLoggedIn:Bool = prefs.boolForKey("isloggedin") as Bool
        return isLoggedIn
    }
    
    func currentUser() -> NSInteger {
        let prefs:NSUserDefaults = NSUserDefaults.standardUserDefaults()
        var userid:NSInteger = prefs.integerForKey("userid") as NSInteger
        return userid
    }

    func userToken() -> String {
        let prefs:NSUserDefaults = NSUserDefaults.standardUserDefaults()
        var token:String = ""
        if prefs.boolForKey("access_token") {
            token = prefs.valueForKey("access_token") as String!
        }
        return token
    }
    
    func logout() -> Bool {
        let prefs:NSUserDefaults = NSUserDefaults.standardUserDefaults()
        var token:String = prefs.valueForKey("access_token") as String!
        var id = currentUser()
        destroy("/sessions/\(token)")
        let appDomain = NSBundle.mainBundle().bundleIdentifier
        NSUserDefaults.standardUserDefaults().removePersistentDomainForName(appDomain!)
        return true
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
