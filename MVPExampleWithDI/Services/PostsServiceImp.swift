//
//  PostsService.swift
//  MVPExample
//
//  Created by JanFranco on 17.12.2020.
//

import Foundation

class PostsServiceImp: PostService {
    
    var networkService: NetworkService
    
    required init(networkService: NetworkService) {
        self.networkService = networkService
    }
    
    func getPosts(completion: @escaping((Result<[Post], APIError>) -> Void)) {
        networkService.get(from: "https://jsonplaceholder.typicode.com/posts", completation: completion)
    }
    
}
