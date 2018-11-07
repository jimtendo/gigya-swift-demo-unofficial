//
//  UserProfileController.swift
//  My First Project
//
//  Created by Carlos Raimundo on 13/04/2017.
//  Copyright © 2017 Gigya. All rights reserved.
//

import UIKit
//import JWT

@objc
protocol CenterViewControllerDelegate {
    @objc optional func toggleLeftPanel()
    @objc optional func toggleRightPanel()
    @objc optional func collapseSidePanels()
}

class UserProfileController: UIViewController {
    
    var delegate: CenterViewControllerDelegate?
    var appDelegate: AppDelegate?
  

   
    @IBOutlet weak var userEmail: UILabel!
    @IBOutlet weak var userFirstName: UILabel!
    @IBOutlet weak var userLastName: UILabel!
    @IBOutlet weak var welcomeLabel: UILabel!
    @IBOutlet weak var profilePic: UIImageView!
    
    var centerViewController: UserProfileController!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.appDelegate = UIApplication.shared.delegate as? AppDelegate
        
       // let remember = appDelegate?.rememberMe
        
      //  NSLog("Remember Me: %@", remember?.description ?? "remember var not set")
        
      //  if(!remember!){
      //      appDelegate?.startTimer()
      //  }
        
        updateSessionInfo()
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func editProfileAction(_ sender: Any) {
        
        let dictionary: [String:String] = [
            "screenSet" : "Default-ProfileUpdate",
            "startScreen" : "gigya-update-profile-screen",
            ]
        
        Gigya.showPluginDialogOver(self, plugin: "accounts.screenSet", parameters: dictionary) { (response: Bool, error: Error?) in
            
            if(error == nil){
                
                if(!response){
                    
                    self.updateSessionInfo()
                    let alert = UIAlertController(title: "Success!", message: "Your profile has been updated", preferredStyle: .alert)
                    self.present(alert, animated: true, completion: nil)
                    Timer.scheduledTimer(withTimeInterval: 2.0, repeats: false, block: { _ in alert.dismiss(animated: true, completion: nil)} )
                    
                }
                
            }
        }

    }
    
    @IBAction func logoutButton(_ sender: Any) {
      self.appDelegate?.accountDidLogout()
      self.dismiss(animated: true, completion: nil)
      //self.performSegue(withIdentifier: "viewController", sender: self)
    }
    
    // MARK: GIGYA
    func updateSessionInfo() {
        if Gigya.isSessionValid() {
             NSLog("Gigya Session is valid", "")
        
            
            if let ad = appDelegate {
                if ad.account == nil {
//                    let dictionary: [String:String] = [
//                        //"UID" : "_guid_bdmRv3gvow6r2hAI-OAkMUJP9P46sM2zkNgO2MkX54k=",
//                    :]
                    
                    let request = GSRequest(forMethod: "accounts.getAccountInfo")
                    //request?.parameters?.setDictionary(dictionary)
                    
                    /* LOG Request fields */
//                    NSLog("request debugDescription %@", request?.debugDescription ?? "noDebugDescription")
//                    NSLog("include auth info: %@", request?.includeAuthInfo.description ?? "includeAuthInfo")
//                    NSLog("accessibilityActivate: %@", request?.accessibilityActivate().description ?? "includeAuthInfo")
//                    NSLog("requestID: %@", request?.requestID ?? "requestID")
//                    NSLog("requestTimeout: %@", request?.requestTimeout.debugDescription ?? "requestTimeout")
//                    NSLog("use HTTPS: %@", request?.useHTTPS.description ?? "requestTimeout")
                    
                    /* Send Request */
                    request!.send(responseHandler: { (response: GSResponse?, error: Error?) in
                        
                        if(error == nil) {
                    
                            //NSLog("response: %@", response?.jsonString() ?? "no token")
                            
                            ad.account = response as? GSAccount
                            let profile = response?["profile"] as? NSDictionary
                            
                           // let email = profile?["email"] as? String
                           
                            self.userEmail.text = profile?["email"] as? String
                            self.userFirstName.text = "\(profile?["firstName"] as! String) \(profile?["lastName"] as! String)"
                        
                            
                            do {
                                if let url = URL(string : (profile?["photoURL"] as! String)) {
                                    let data = try Data(contentsOf: url)
                                    self.profilePic.image = UIImage(data: data)
                                }
                            }catch{
                                print(error)
                            }
                        }
                        
                    })

                }

            }
        }else {
            
        }
    }
    
    
    // Touch event resets
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if touches.first != nil {
            appDelegate?.resetTimer()
        }
        
        super.touchesBegan(touches, with: event)
    }
    
    
    @IBAction func updateProfileAction(_ sender: UIButton) {
        
        // AG inject gigya update profile screenset
        /*gigya.accounts.showScreenSet({
         screenSet: screenSetPrefix + '-ProfileUpdate',
         containerID: 'gigya-profile-container',
         startScreen: 'gigya-update-profile-screen'
         });*/
        
        let dictionary: [String:String] = [
            "screenSet" : "Default-ProfileUpdate",
            "startScreen" : "gigya-update-profile-screen",
            ]
        
        Gigya.showPluginDialogOver(self, plugin: "accounts.screenSet", parameters: dictionary) { (response: Bool, error: Error?) in
            
            if(error == nil){
                
                if(!response){
                    
                    self.updateSessionInfo()
                    let alert = UIAlertController(title: "Success!", message: "Your profile has been updated", preferredStyle: .alert)
                    self.present(alert, animated: true, completion: nil)
                    Timer.scheduledTimer(withTimeInterval: 2.0, repeats: false, block: { _ in alert.dismiss(animated: true, completion: nil)} )
                    
                }
               
            }
        }
        
    }
    
    @IBAction func getJWTToken(_ sender: Any) {
        
        let dictionary: [String:String] = [
            "expiration" : "31557600",
            ]
        
        let request = GSRequest(forMethod: "accounts.getJWT")
        request?.parameters?.setDictionary(dictionary)
        
        
        /* LOG Request fields */
        NSLog("request debugDescription %@", request?.debugDescription ?? "noDebugDescription")
        //NSLog("include auth info: %@", request?.includeAuthInfo.description ?? "includeAuthInfo")
        //NSLog("accessibilityActivate: %@", request?.accessibilityActivate().description ?? "includeAuthInfo")
        //NSLog("requestID: %@", request?.requestID ?? "requestID")
        //NSLog("requestTimeout: %@", request?.requestTimeout.debugDescription ?? "requestTimeout")
        //NSLog("use HTTPS: %@", request?.useHTTPS.description ?? "requestTimeout")
        
        /* Send Request */
        request!.send(responseHandler: { (response: GSResponse?, error: Error?) in
            
            if(error == nil) {
                
                let token = (response?["id_token"] as AnyObject).description
                
                NSLog("response: %@", token ?? "no token")
                
                 let publicKey = "qoQah4MFGYedrbWwFc3UkC1hpZlnB2_E922yRJfHqpq2tTHL_NvjYmssVdJBgSKi36cptKqUJ0Phui9Z_kk8zMPrPfV16h0ZfBzKsvIy6_d7cWnn163BMz46kAHtZXqXhNuj19IZRCDfNoqVVxxCIYvbsgInbzZM82CB86iYPAS7piijYn1S6hueVHGAzQorOetZevKIAvbH3kJXZ4KdY6Ffz5SFDJBxC3bycN4q2JM1qnyD53vcc0MitxyIUF7a06iJb5_xXBiA-3xnTI0FU5hw_k6x-sdB5Rglx13_2aNzdWBSBAnxs1XXtZUt9_2RAUxP1XORkrBGlPg9D7cBtQ"
                
                
                let algorithmName = "RS256";
                
                let alertController = UIAlertController(title: "JWT TOKEN", message: token ?? "no token", preferredStyle: UIAlertControllerStyle.alert)
                
                let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
                    (result : UIAlertAction) -> Void in
                    // self.performSegue(withIdentifier: "userProfile", sender: self)
                }
                
                alertController.addAction(okAction)
                self.present(alertController, animated: true, completion: nil)
                
            }
        })

    }
    
    
    @IBAction func validateJWT(_ sender: Any) {
        
        let dictionary: [String:String] = [
            //"targetUID" : "_guid_bdmRv3gvow6r2hAI-OAkMUJP9P46sM2zkNgO2MkX54k=",
            :]
        
        let request = GSRequest(forMethod: "accounts.getJWTPublicKey")
        request?.parameters?.setDictionary(dictionary)
        
        
        /* LOG Request fields */
        NSLog("request debugDescription %@", request?.debugDescription ?? "noDebugDescription")
    
        
        /* Send Request */
        request!.send(responseHandler: { (response: GSResponse?, error: Error?) in
            
            if(error == nil) {
                
                //let token = (response?["id_token"] as AnyObject).description
                
                //NSLog("response: %@", response?.jsonString() ?? "no token")
                
                //NSLog("N: %@", response?.jsonString() ?? "my n is not here")
                
                let publicKey = (response?["n"] as AnyObject) as! String
                let id_token = (response?["e"] as AnyObject) as! String
                
                NSLog("The modulus. A base64url encoding of the returned id_token: %@",response?.jsonString() ?? "my n is not here")
                //NSLog("The exponent value for the RSA public key: %@",id_token ?? "my n is not here")
                
                
                /* 
                 
                 // Decode
                 // Suppose, that you get token from previous example. You need a valid public key for a private key in previous example.
                 // Private key stored in @"secret_key.p12". So, you need public key for that private key.
                 NSString *publicKey = @"..."; // load public key. Or use it as raw string.
                 
                 algorithmName = @"RS256";
                 
                 JWTBuilder *decodeBuilder = [JWTBuilder decodeMessage:token].secret(publicKey).algorithmName(algorithmName);
                 NSDictionary *envelopedPayload = decodeBuilder.decode;
                 
                 // check error
                 if (decodeBuilder.jwtError == nil) {
                 // handle result
                 }
                 else {
                 // error occurred.
                 }
                 
                 */
                
                
            }
        })
        
    }
    
    
    func done() {
        
    }
}


