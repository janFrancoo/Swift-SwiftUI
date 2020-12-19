//
//  Fact.swift
//  GenericAPIClientExample
//
//  Created by JanFranco on 14.12.2020.
//

import Foundation

struct Fact: Codable {
    
    struct Status: Codable {
        var verified: Bool?
        var sentCount: Int?
    }
    
    var _id: String?
    var __v: Int?
    
    var user: String?
    var type: String?
    var text: String?

    var updatedAt: String?
    var createdAt: String?
    var used: Bool?
    
    enum source: String, Codable {
        case user
        case api
    }

}
