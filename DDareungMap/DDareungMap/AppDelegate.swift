//
//  AppDelegate.swift
//  DDareungMap
//
//  Created by 김동현 on 2020/10/18.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let vc = ViewController()
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = vc
        
        Service.shared.getData1 { (stationInfos) in
            self.window?.makeKeyAndVisible()
            vc.stationInfos = stationInfos
        }
        
        return true
    }

}

