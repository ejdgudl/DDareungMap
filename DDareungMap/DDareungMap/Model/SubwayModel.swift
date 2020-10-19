//
//  SubwayModel.swift
//  DDareungMap
//
//  Created by 김동현 on 2020/10/19.
//

import Foundation

struct ResultSubwayData: Codable {
    
    let searchInfoBySubwayNameService: SearchInfoBySubwayNameService
    
    enum CodingKeys: String, CodingKey {
        case searchInfoBySubwayNameService = "SearchInfoBySubwayNameService"
    }
    
}

struct SearchInfoBySubwayNameService: Codable {
    
    let row: [SubStationInfo]
    
}

struct SubStationInfo: Codable {
    
    let stationName: String
    let lineNum: String
    
    enum CodingKeys: String, CodingKey {
        case stationName = "STATION_NM"
        case lineNum = "LINE_NUM"
    }
    
}
