//
//  AlamoClient.swift
//  MVPExample
//
//  Created by JanFranco on 17.12.2020.
//

import Foundation
import Alamofire
import SwiftyJSON

class AlamoClient: NetworkService {
    
    func get<T>(from url: String, completation: @escaping ((Result<T, APIError>) -> Void)) where T : Decodable, T : Encodable {
        AF.request(url).responseJSON { response in
            if response.error != nil {
                completation(.failure(.serverError))
            }
            
            guard let data = response.data else { completation(.failure(.serverError)); return }
                    
            do {
                let decoder = JSONDecoder()
                let decoded = try decoder.decode(T.self, from: data)
                completation(.success(decoded))
            } catch let error {
                print(error)
                completation(.failure(.parsingError))
            }
        }
    }
    
}
