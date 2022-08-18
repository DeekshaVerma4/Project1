//  AppDelegate.swift
//  MobileCodingChallenge
//  Created by Deeksha Verma on 16/08/22.

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    var navigationController1 : UINavigationController!
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let initialViewController : UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ViewController") as UIViewController
        self.window = UIWindow(frame: UIScreen.main.bounds)
        navigationController1 = UINavigationController()
        navigationController1.viewControllers = [initialViewController]
        self.window!.rootViewController = navigationController1
        self.window?.makeKeyAndVisible()
        Util.copyDatabase("Signup.db")
        return true
    }
}

