//
//  UnsplashPhoto.swift
//  MVVMRxSwiftExample
//
//  Created by JanFranco on 28.05.2021.
//

struct UnsplashPhoto: Codable {
    let id: String?
    let description: String?
    let altDescription: String?
    let urls: Urls?
    
    enum CodingKeys: String, CodingKey {
        case id, description
        case altDescription = "alt_description"
        case urls
    }
}

struct Urls: Codable {
    let raw: String?
    let full: String?
    let regular: String?
    let small: String?
    let thumb: String?
    
    enum CodingKeys: String, CodingKey {
        case raw, full, regular, small, thumb
    }
}
