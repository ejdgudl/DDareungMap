//
//  Model.swift
//  DDareungMap
//
//  Created by 김동현 on 2020/10/18.
//

import Foundation
import CoreLocation


struct ResultData: Codable {
    let rentBikeStatus: RentBikeStatus
}

struct RentBikeStatus: Codable {
    let row: [StationInfo]
}

struct StationInfo: Codable {
    
    let dockCount: String // 거치대개수
    let stationName: String  // 대여소이름
    let parkingCount: String // 자전거 주차 총 건수
    let lat: String
    let lon: String
    let stationID: String // 대여소ID
    
    var coordinate: CLLocationCoordinate2D? {
        return CLLocationCoordinate2D(latitude: CLLocationDegrees(lat)!, longitude: CLLocationDegrees(lon)!)
    }

    enum CodingKeys: String, CodingKey {
        case dockCount = "rackTotCnt"
        case stationName
        case parkingCount = "parkingBikeTotCnt"
        case lat = "stationLatitude"
        case lon = "stationLongitude"
        case stationID = "stationId"
    }
    
}
