//
//  TaskBuilder.swift
//  BuilderPatternExample
//
//  Created by JanFranco on 10.12.2020.
//

import Foundation

class TaskBuilder {
    private(set) var request: URLRequest!
    
    public func setRequest(_ request: URLRequest) {
        self.request = request
    }
    
    public func build() -> URLSessionDataTask {
        assert(request != nil)
        
        return URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data,
                  let response = response as? HTTPURLResponse,
                  (200 ..< 300) ~= response.statusCode,
                  error == nil else {
                return
            }
            
            if let responseObject = (try? JSONSerialization.jsonObject(with: data)) as? [String: Any] {
                print(responseObject)
            }
        }
    }
}
