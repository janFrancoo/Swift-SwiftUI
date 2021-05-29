//
//  DataToImageConversionService.swift
//  MVVMRxSwiftExample
//
//  Created by JanFranco on 29.05.2021.
//

import UIKit

protocol DataToImageConversionService: class {
    func getImage(from data: Data) -> UIImage?
}

class DataToImageConversionServiceImpl: DataToImageConversionService {
    
    func getImage(from data: Data) -> UIImage? {
        return UIImage(data: data)
    }
}
