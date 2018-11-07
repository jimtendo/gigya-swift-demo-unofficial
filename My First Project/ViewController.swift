//
//  ViewController.swift
//  My First Project
//
//  Created by Carlos Raimundo on 11/04/2017.
//  Copyright © 2017 Gigya. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var myTextField: UITextField!
    @IBOutlet var mySwitch: UISwitch?
    var centerViewController: ViewController!
    var ap: AppDelegate?
    @IBOutlet weak var registerLabel: UILabel!

    @IBOutlet weak var forgotPwLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.ap = UIApplication.shared.delegate as! AppDelegate
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.registerAction))
        registerLabel.isUserInteractionEnabled = true
        registerLabel.addGestureRecognizer(tap)
        
        mySwitch?.setOn((ap?.rememberMe!)!, animated: true)
    }
    
    @IBAction func forgetPwAction(_ sender: Any) {
        
        let dictionary: [String:String] = [
            "screenSet" : "Default-RegistrationLogin",
            "startScreen" : "gigya-forgot-password-screen",
            ]
        
        Gigya.showPluginDialogOver(self, plugin: "accounts.screenSet", parameters: dictionary) { (response: Bool, error: Error?) in
            
            if(error == nil){
                
                if(!response){
                    //self.performSegue(withIdentifier: "userProfile", sender: self)
                }
                
            }
        }

    }
    
    @IBAction func switchRememberMe(sender: UISwitch) {
        
        if (sender.isOn) {
            UserDefaults.standard.set(true, forKey: "rememberMe")
            self.ap?.rememberMe = true
        }else{
            UserDefaults.standard.set(false, forKey: "rememberMe")
            self.ap?.rememberMe = false
        }

    }
    
    
    @IBAction func mySecondButton(_ sender: Any) {
        
        if(!Gigya.isSessionValid()){
            
            let dictionary: [String:String] = [
                "sample" : "keySample"
            ]
            
            Gigya.login(toProvider: "facebook", parameters: dictionary, over: self) { (user, error) in

                if(error == nil) {
                    NSLog("No Errors", "")
                    let ap = UIApplication.shared.delegate as! AppDelegate
                    ap.user = user;
                    
                    self.performSegue(withIdentifier: "userProfile", sender: self)
                    
                } else {
                    NSLog("Error!!!! : %@", error.debugDescription)
                    
                }
            }
        } else {
            NSLog("SESSION VALID !!!!", "")
            self.performSegue(withIdentifier: "userProfile", sender: self)
        }
        
    }
    
    @IBAction func googleLogin(_ sender: Any) {
    
        if(!Gigya.isSessionValid()){
            
            NSLog("SESSION NOT VALID !!!!", "")
        
        
        let dictionary: [String:String] = [
            "td" : "d",
            ]
    
        Gigya.login(toProvider: "googleplus", parameters: dictionary, over: self) { (user, error) in
            
            if(error == nil) {
                NSLog("No Errors", "")
                let ap = UIApplication.shared.delegate as! AppDelegate
                ap.user = user;
                
                self.dismiss(animated: true, completion: nil)
                self.performSegue(withIdentifier: "userProfile", sender: self)
                
            } else {
                NSLog("Error!!!! : %@", error?.localizedDescription ?? "noerr")
            }
        }
            
        } else {
            NSLog("SESSION VALID !!!!", "")
            self.performSegue(withIdentifier: "userProfile", sender: self)
        }
    }
    
    func registerAction(sender:UITapGestureRecognizer) {
        let dictionary: [String:String] = [
            "screenSet" : "Default-RegistrationLogin",
            "startScreen" : "gigya-register-screen",
            ]
        
        Gigya.showPluginDialogOver(self, plugin: "accounts.screenSet", parameters: dictionary) { (response: Bool, error: Error?) in
            
            if(error == nil){
                
                if(!response){
                    self.performSegue(withIdentifier: "userProfile", sender: self)
                }
                
            }
        }

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

