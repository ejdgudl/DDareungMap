//
//  SubwayService.swift
//  DDareungMap
//
//  Created by 김동현 on 2020/10/19.
//

import Foundation
import Alamofire

final class SubwayService {
    
    static let shared = SubwayService()
    
    let myKey = "7441535158656a643736495769544f"
    
    lazy var url = "http://openAPI.seoul.go.kr:8088/\(myKey)/json/SearchInfoBySubwayNameService/1/750"
    
    func getData(completion: @escaping ([SubStationInfo]) -> () ) {
        AF.request(url, method: .get).response { (ref) in
            if let error = ref.error {
                print(error.localizedDescription)
            }
            
            guard let statusCode = ref.response?.statusCode else {
                return
            }
            
            if (200...299).contains(statusCode) {
                
                switch ref.result {
                
                case .success(let data):
                    
                    guard let data = data else {
                        return
                    }
                    
                    do {
                        
                        let jsonData = try JSONDecoder().decode(ResultSubwayData.self, from: data)
                        
                        let stationInfos = jsonData.searchInfoBySubwayNameService.row
                        completion(stationInfos)

                        print("----- AF SubwayInfo [SUCESS] 1...750 get data! -----")
                    } catch let error {
                        print(error.localizedDescription)
                        print("----- JsonDecoder [ERROR] -----")
                    }
                    
                    
                case .failure(let error):
                    print("----- AF [FAIL] result is fail... -----")
                    print(error.localizedDescription)
                }
            } else {
                print("----- AF [FAIL] status code is contains 300... -----")
            }
            
        }
    }
    
    private init() {
        
    }
    
}
