//
//  SwinjectStoryboard+Setup.swift
//  SwinjectExample
//
//  Created by JanFranco on 16.12.2020.
//

import SwinjectStoryboard

extension SwinjectStoryboard {
    class func setup() {
        defaultContainer.storyboardInitCompleted(ViewController.self) { r, c in
            c.weatherFetcher = r.resolve(WeatherFetcher.self)
        }
        
        defaultContainer.register(NetworkService.self) { _ in Network() }
        defaultContainer.register(WeatherFetcher.self) { r in
            WeatherFetcher(networkService: r.resolve(NetworkService.self)!)
        }
    }
}
