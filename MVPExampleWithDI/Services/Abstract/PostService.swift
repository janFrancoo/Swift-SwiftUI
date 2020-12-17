//
//  PostServicee.swift
//  MVPExample
//
//  Created by JanFranco on 17.12.2020.
//

import Foundation

protocol PostService {
    init(networkService: NetworkService)
    func getPosts(completion: @escaping((Result<[Post], APIError>) -> Void))
}
