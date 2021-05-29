//
//  PhotoDetailViewController.swift
//  MVVMRxSwiftExample
//
//  Created by JanFranco on 29.05.2021.
//

import UIKit

class PhotoDetailViewController: UIViewController {
    
    var photoId: String? = nil

    override func viewDidLoad() {
        super.viewDidLoad()

        print(photoId ?? "error")
    }
}
