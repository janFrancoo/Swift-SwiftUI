//
//  CatFactAPI.swift
//  GenericAPIClientExample
//
//  Created by JanFranco on 14.12.2020.
//

import Foundation
import Combine

class CatFactAPI: CatFactProvider {
    
    private let baseUrl = "https://cat-fact.herokuapp.com"
    
    private enum endpoint: String {
        case random = "/facts/random"
    }
    
    private enum method: String {
        case GET
    }
    
    func randomFact(completion: @escaping ((Result<Fact, APIError>) -> Void)) {
        request(endpoint: .random, method: .GET, completion: completion)
    }
    
    private func request(endpoint: endpoint, method: method) -> URLRequest {
        let path = "\(baseUrl)\(endpoint.rawValue)"
        
        guard let url = URL(string: path) else {
            preconditionFailure("Bad URL")
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "\(method)"
        request.allHTTPHeaderFields = ["Content-Type": "application/json"]
        return request
    }
    
    private func request<T: Codable>(endpoint: endpoint, method: method,
                                     completion: @escaping((Result<T, APIError>) -> Void)) {
        let path = "\(baseUrl)\(endpoint.rawValue)"
        
        guard let url = URL(string: path) else {
            completion(.failure(.internalError))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "\(method)"
        request.allHTTPHeaderFields = ["Content-Type": "application/json"]
        
        call(with: request, completion: completion)
    }
    
    private func call<T: Codable>(with request: URLRequest,
                                  completion: @escaping((Result<T, APIError>) -> Void)) {
        let dataTask = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard error == nil else {
                completion(.failure(.serverError))
                return
            }
            
            do {
                guard let data = data else {
                    completion(.failure(.serverError))
                    return
                }
                let object = try JSONDecoder().decode(T.self, from: data)
                completion(.success(object))
                
            } catch {
                completion(.failure(.parsingError))
            }
        }
        
        dataTask.resume()
    }
    
    private func call<T: Codable>(_ endpoint: endpoint, method: method) -> AnyPublisher<T, APIError> {
        let urlRequest = request(endpoint: .random, method: .GET)
        return URLSession.shared.dataTaskPublisher(for: urlRequest)
            .mapError { _ in APIError.serverError }
            .map { $0.data }
            .decode(type: T.self, decoder: JSONDecoder())
            .mapError { _ in APIError.parsingError }
            .eraseToAnyPublisher()
    }
    
    func randomFact() -> AnyPublisher<Fact, APIError> {
        return call(.random, method: .GET)
    }
    
}
