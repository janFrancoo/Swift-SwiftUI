//
//  Client.swift
//  MVVMRxSwiftExample
//
//  Created by JanFranco on 29.05.2021.
//

import Foundation
import RxSwift

final class NetworkClient {
    
    typealias Parameters = [String: String]
    
    var baseURL: URL?
    
    init() {
        self.baseURL = URL(string: Constants.BASE_URL)
    }
    
    func get<T: Decodable>(
        _ type: T.Type,
        _ urlString: String,
        parameters: Parameters = [:],
        log: Bool = false
    ) -> Observable<(T?, Error?)> {
        
        return Observable.create { [unowned self] observer in
            
            guard let url = URL(string: urlString, relativeTo: self.baseURL) else {
                observer.onNext((nil, NetworkError.invalidURL))
                return Disposables.create()
            }
            
            guard var urlComponents = URLComponents(string: url.absoluteString) else {
                observer.onNext((nil, NetworkError.invalidURL))
                return Disposables.create()
            }
            
            if !parameters.isEmpty {
                urlComponents.queryItems = parameters.compactMap { key, value in
                    URLQueryItem(name: key, value: value)
                }
            }
            
            var urlRequest = URLRequest(url: urlComponents.url!)
            urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
            urlRequest.addValue("Client ID \(Constants.API_KEY)", forHTTPHeaderField: "Authorization")
            
            let task = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
                guard let data = data, let response = response as? HTTPURLResponse, (200..<300) ~= response.statusCode else {
                    if let error = error {
                        observer.onNext((nil, error))
                    } else {
                        observer.onNext((nil, NetworkError.unknown))
                    }
                    return
                }
                
                do {
                    let model = try JSONDecoder().decode(type, from: data)
                    observer.onNext((model, nil))
                } catch {
                    observer.onNext((nil, NetworkError.decodeFailed))
                }
            }
            
            task.resume()
            
            return Disposables.create {
                task.cancel()
            }
        }
    }
    
    func getArray<T: Decodable>(
        _ type: [T].Type,
        _ urlString: String,
        parameters: Parameters = [:]
    ) -> Observable<([T]?, Error?)> {
        
        return Observable.create { [unowned self] observer in
            
            guard let url = URL(string: urlString,
                                relativeTo: self.baseURL) else {
                observer.onNext((nil, NetworkError.invalidURL))
                return Disposables.create()
            }
            guard var urlComponents = URLComponents(string: url.absoluteString) else {
                observer.onNext((nil, NetworkError.invalidURL))
                return Disposables.create()
            }
            
            if !parameters.isEmpty {
                urlComponents.queryItems = parameters.compactMap {
                    URLQueryItem(name: $0.key, value: $0.value)
                }
            }
            
            var urlRequest = URLRequest(url: urlComponents.url!)
            urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
            urlRequest.addValue("Client-ID \(Constants.API_KEY)", forHTTPHeaderField: "Authorization")
            
            let task = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
                guard let data = data,
                      let response = response as? HTTPURLResponse, (200..<300) ~= response.statusCode else {
                    if let error = error {
                        observer.onNext((nil, error))
                    } else {
                        observer.onNext((nil, NetworkError.unknown))
                    }
                    return
                }
                
                do {
                    let model = try JSONDecoder().decode(type, from: data)
                    observer.onNext((model, nil))
                } catch {
                    observer.onNext((nil, error))
                }
                
            }
            
            task.resume()
            
            return Disposables.create {
                task.cancel()
            }
        }
    }
    
    static func getData(_ url: URL) -> Observable<(Data?, Error?)> {
        
        return Observable.create { observer in
            
            let session = URLSession(configuration: .ephemeral)
            
            let task = session.dataTask(with: url) { data, response, error in
                guard let data = data,
                      let response = response as? HTTPURLResponse, (200..<300) ~= response.statusCode else {
                    if let error = error {
                        observer.onNext((nil, error))
                    } else {
                        observer.onNext((nil, NetworkError.unknown))
                    }
                    return
                }
                
                observer.onNext((data, nil))
            }
            
            task.resume()
            
            return Disposables.create {
                session.finishTasksAndInvalidate()
            }
        }
    }
}
