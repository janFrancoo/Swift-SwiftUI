//
//  WeatherFetcher.swift
//  SwinjectExample
//
//  Created by JanFranco on 16.12.2020.
//

import Foundation
import Alamofire
import SwiftyJSON

struct WeatherFetcher {
    let networkService: NetworkService
    
    func fetch(_ response: @escaping ([City]?) -> ()) {
        networkService.request { data in
            let cities = data.map { self.decode($0 as Data) }
            response(cities)
        }
    }
    
    fileprivate func decode(_ data: Data) -> [City] {
        do {
            let json = try JSON(data: data)
            var cities = [City]()
            
            for (_, j) in json["list"] {
                if let id = j["id"].int {
                    cities.append(City(id: id, name: j["name"].string ?? "", weather: j["weather"][0]["main"].string ?? ""))
                }
            }
            
            return cities
        } catch {
            return []
        }
    }
}
