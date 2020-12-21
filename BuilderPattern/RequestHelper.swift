//
//  Request.swift
//  BuilderPatternExample
//
//  Created by JanFranco on 10.12.2020.
//

enum Method: String {
    case GET
    case POST
}

struct RequestBaseUrls {
    static let gitHub = "https://api.github.com"
}

struct RequestEndpoints {
    static let searchRepositories = "/search/repositories"
}
