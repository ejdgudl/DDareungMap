//
//  SetRegionCase.swift
//  DDareungMap
//
//  Created by 김동현 on 2020/10/18.
//

import Foundation
import CoreLocation

enum SetRegionCase {
    
    case test
    case viewDidAppear
    case goToCurrentLocation
    case didSelect(CLLocationCoordinate2D)
    case didDeSelect(CLLocationCoordinate2D)
    
}
