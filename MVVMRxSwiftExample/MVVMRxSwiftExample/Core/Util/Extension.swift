//
//  Extension.swift
//  MVVMRxSwiftExample
//
//  Created by JanFranco on 28.05.2021.
//

import UIKit

protocol ReuseIdentifiable: class {
    static var reuseIdentifier: String { get }
}

extension ReuseIdentifiable {
    static var reuseIdentifier: String { .init(describing: self) }
}

extension UICollectionViewCell: ReuseIdentifiable { }
extension UITableViewCell: ReuseIdentifiable { }
