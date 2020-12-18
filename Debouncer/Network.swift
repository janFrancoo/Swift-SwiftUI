//
//  Network.swift
//  DebouncerExample
//
//  Created by JanFranco on 8.12.2020.
//

import Foundation
import Reachability

class Network {
    private lazy var reachability: Reachability = try! Reachability()
    
    public func isNetworkAvailable() -> Bool {
        reachability.connection != .unavailable
    }
}
