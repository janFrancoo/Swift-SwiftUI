//
//  Dimension.swift
//  MVVMRxSwiftExample
//
//  Created by JanFranco on 28.05.2021.
//

import UIKit

struct Dimensions {
    
    static let screenWidth: CGFloat = UIScreen.main.bounds.width
    static let screenHeight: CGFloat = UIScreen.main.bounds.height
    
    static let photosItemSize = CGSize(width: Dimensions.screenWidth * 0.45, height: Dimensions.screenWidth * 0.45)
}
