//
//  Service.swift
//  DDareungMap
//
//  Created by 김동현 on 2020/10/18.
//

import Foundation
import Alamofire

final class Service {
    
    // MARK: - Properties
    static let shared = Service()
    
    let myKey = "6c716d426d656a64373165575a524f"
    
    lazy var url = "http://openapi.seoul.go.kr:8088/\(myKey)/json/bikeList/1/500/"
    
    // MARK: - Helpers
    func getData(completion: @escaping ([StationInfo]) -> ()) {
        
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
                        
                        let jsonData = try JSONDecoder().decode(ResultData.self, from: data)
                        
                        let stationInfos = jsonData.rentBikeStatus.row
                        completion(stationInfos)
                        print(stationInfos)
                        print("----- AF [SUCESS] get data! -----")
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

    
    // MARK: - Init
    private init() {
        
    }
    
}
