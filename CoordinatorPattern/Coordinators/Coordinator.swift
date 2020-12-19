//
//  Coordinator.swift
//  CoordinatorPatternExample
//
//  Created by JanFranco on 9.12.2020.
//

protocol Coordinator {
    func start()
    func coordinate(to coordinator: Coordinator)
}

extension Coordinator {
    func coordinate(to coordinator: Coordinator) {
        coordinator.start()
    }
}
