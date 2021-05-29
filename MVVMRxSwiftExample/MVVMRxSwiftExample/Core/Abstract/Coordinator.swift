//
//  Coordinator.swift
//  MVVMRxSwiftExample
//
//  Created by JanFranco on 28.05.2021.
//

protocol Coordinator: class {
    func start()
    func coordinate(to coordinator: Coordinator)
}

extension Coordinator {
    func coordinate(to coordinator: Coordinator) {
        coordinator.start()
    }
}
