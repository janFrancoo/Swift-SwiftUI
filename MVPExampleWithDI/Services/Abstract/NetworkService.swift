//
//  NetworkService.swift
//  MVPExample
//
//  Created by JanFranco on 17.12.2020.
//

import Foundation

protocol NetworkService {
    func get<T: Codable>(from url: String, completation: @escaping((Result<T, APIError>) -> Void))
}
