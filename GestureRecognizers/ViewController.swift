//
//  ViewController.swift
//  GestureRecognizerTutorial
//
//  Created by JanFranco on 26.01.2020.
//  Copyright © 2020 janfranco. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var image: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        image.isUserInteractionEnabled = true
        let gestureRecoginizer = UITapGestureRecognizer(target: self, action: #selector(changePic))
        image.addGestureRecognizer(gestureRecoginizer)
    }
    
    @objc func changePic() {
        image.image = UIImage(named: "maceo")
    }

}
