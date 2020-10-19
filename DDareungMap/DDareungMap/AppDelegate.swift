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
    var stationInfos = [StationInfo]()
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let vc = ViewController()
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = vc
        window?.makeKeyAndVisible()
        
        Service.shared.getData1 { (stationInfos) in
            self.stationInfos = stationInfos
            Service.shared.getData2 { (stationInfos) in
                self.stationInfos.append(contentsOf: stationInfos)
                vc.stationInfos = self.stationInfos
            }
        }
        
        return true
    }

}

