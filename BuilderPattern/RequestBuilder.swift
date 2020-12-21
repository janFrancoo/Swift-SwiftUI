//
//  RequestBuilder.swift
//  BuilderPatternExample
//
//  Created by JanFranco on 10.12.2020.
//

import Foundation

class RequestBuilder {
    private(set) var baseURL: URL!
    private(set) var endpoint: String = ""
    private(set) var method: Method = .GET
    private(set) var headers: [String: String] = [:]
    private(set) var parameters: [String: String] = [:]
    
    public func setBaseUrl(_ string: String) {
        baseURL = URL(string: string)!
    }
    
    public func setEndpoint(_ value: String) {
        endpoint = value
    }
    
    public func setMethod(_ value: Method) {
        method = value
    }
    
    public func addHeader(_ key: String, _ value: String) {
        headers[key] = value
    }
    
    public func addParameter(_ key: String, _ value: String) {
        parameters[key] = value
    }
    
    public func build() -> URLRequest {
        assert(baseURL != nil)
        
        let url = baseURL.appendingPathComponent(endpoint)
        var components = URLComponents(string: url.absoluteString)!
        
        components.queryItems = parameters.compactMap {
            URLQueryItem(name: $0.key, value: $0.value)
        }
        
        var urlRequest = URLRequest(url: components.url!)
        urlRequest.httpMethod = method.rawValue
        
        for header in headers {
            urlRequest.addValue(header.value, forHTTPHeaderField: header.key)
        }
        
        return urlRequest
    }
}
