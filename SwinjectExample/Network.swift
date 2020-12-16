//
//  Network.swift
//  SwinjectExample
//
//  Created by JanFranco on 16.12.2020.
//

import Foundation
import Alamofire

struct Network: NetworkService {
    func request(_ networkResponse: @escaping (Data?) -> ()) {
        AF.request(OpenWeatherMap.url, parameters: OpenWeatherMap.parameters).responseData { (dataResponse) in
            networkResponse(dataResponse.data)
        }
    }
    
}
