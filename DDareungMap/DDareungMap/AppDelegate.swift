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
    var stationInfos = [StationInfo]() /// 2번에 나눠서 요청하기 때문에 기억해놓을 [StationInfo]
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        let vc = ViewController()
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = vc
        window?.makeKeyAndVisible()
        
        // MARK: - Bike Service
        BikeService.shared.getData1 { (stationInfos) in
            self.stationInfos = stationInfos
            BikeService.shared.getData2 { (stationInfos) in
                self.stationInfos.append(contentsOf: stationInfos)
                vc.bikeStationInfos = self.stationInfos
            }
        }
        
        // MARK: - Subway Service
        SubwayService.shared.getData { subStationInfo in
            vc.subStationInfos = subStationInfo
        }
        
        /// UserInterfaceStyle
        if #available(iOS 13.0, *) {
          self.window?.overrideUserInterfaceStyle = .light
        }
        
        return true
    }

}

