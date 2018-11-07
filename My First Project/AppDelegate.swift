//
//  AppDelegate.swift
//  My First Project
//
//  Created by Carlos Raimundo on 11/04/2017.
//  Copyright © 2017 Gigya. All rights reserved.
//

import UIKit
//import JWT

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var user: GSUser?
    var account: GSAccount?
    var rememberMe : Bool?
    var timer : Timer?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        Gigya.initWithAPIKey("3_n6HDyxNJWZ9C6j1JcQrexeRptHoiCayyzLQ0pXGd05WwXoYNaZAC83wQ2F7kCLWN", application : application, launchOptions : launchOptions , apiDomain : "eu1.gigya.com")
     
        rememberMe = UserDefaults.standard.bool(forKey: "rememberMe")
        
        
        self.window = UIWindow(frame: UIScreen.main.bounds)
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        var initialViewController = storyboard.instantiateViewController(withIdentifier: "ViewController")
        
        if(((rememberMe)!) && Gigya.isSessionValid()){
            initialViewController = storyboard.instantiateViewController(withIdentifier: "UserProfileController")
        }
    
        
        self.window?.rootViewController = initialViewController
        self.window?.makeKeyAndVisible()
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

  
    func application(_ application: UIApplication, url: URL!, sourceApplication: String?, annotation: Any) -> Bool {
      return Gigya.handleOpen(url,application: application,sourceApplication: sourceApplication,annotation: annotation)
    }

    func application(_ app: UIApplication, url: URL!, options: [String : Any] = [:]) -> Bool {
       return Gigya.handleOpen(url, app: app, options: options)
    }
    
    func applicationProtectedDataDidBecomeAvailable(_ application: UIApplication) {
        Gigya.handleDidBecomeActive();
    }
    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        /*let checkFB = FBSDKApplicationDelegate.sharedInstance().application(application, open: url, sourceApplication: sourceApplication, annotation: annotation)*/
        let checkGoogle = GIDSignIn.sharedInstance().handle(url as URL!,sourceApplication: sourceApplication,annotation: annotation)
        //return checkGoogle || checkFB
        return checkGoogle
 
    }
    
    func accountDidLogin(response: GSAccount){
        NSLog("accountDidLogout", "")
    }
    
    
    func accountDidLogout(){
       NSLog("accountDidLogout", "")
        Gigya.logout { (response: GSResponse?, error: Error?) in
            if(error == nil){
                NSLog("Response: %@" , response?.jsonString() ?? "No Response")
                if("200" == (response?["statusCode"] as AnyObject).description){
                    self.backToViewController();
                    self.stopTimer()
                }
                
            }else{
                NSLog("Error Logout: %@", error.debugDescription)
            }
        }

    }
    
    /* TIMER FUNCTIONS - INIT */
    
    func startTimer() {
        
        if timer == nil {
            NSLog("startTimer", "")
            timer =  Timer.scheduledTimer(
                timeInterval: TimeInterval(60),
                target      : self,
                selector    : #selector(self.accountDidLogout),
                userInfo    : nil,
                repeats     : true)
        }
    }
    
    func resetTimer(){
        
        if timer != nil {
            NSLog("resetTimer", "")
            timer?.invalidate()
            timer = nil
            startTimer()
        }
    }
    
    func stopTimer(){
        
        if timer != nil {
            NSLog("stopTimer", "")
            timer?.invalidate()
            timer = nil
        }
    }
    

    /* TIMER FUNCTIONS - END */
    
    func backToViewController() -> Void{
        
        self.window = UIWindow(frame: UIScreen.main.bounds)
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        var initialViewController = storyboard.instantiateViewController(withIdentifier: "ViewController")
        
        self.window?.rootViewController = initialViewController
        self.window?.makeKeyAndVisible()

    }
}

