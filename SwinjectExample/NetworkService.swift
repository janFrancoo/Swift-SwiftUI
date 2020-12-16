//
//  NetworkService.swift
//  SwinjectExample
//
//  Created by JanFranco on 16.12.2020.
//

import Foundation

protocol NetworkService {
    func request(_ response: @escaping (Data?) -> ())
}
