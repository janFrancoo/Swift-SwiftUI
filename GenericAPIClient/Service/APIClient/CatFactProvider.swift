//
//  CatFactProvider.swift
//  GenericAPIClientExample
//
//  Created by JanFranco on 14.12.2020.
//

import Foundation
import Combine

enum APIError: Error {
    case internalError
    case serverError
    case parsingError
}

protocol CatFactProvider {
    func randomFact(completion: @escaping((Result<Fact, APIError>) -> Void))
    // MARK: Combine
    func randomFact() -> AnyPublisher<Fact, APIError>
}
