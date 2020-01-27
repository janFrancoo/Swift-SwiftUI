//
//  ViewController.swift
//  HelloWorld
//
//  Created by JanFranco on 24.01.2020.
//  Copyright © 2020 janfranco. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func change(_ sender: Any) {
        imageView.image = UIImage(named : "victor")
    }
    	
}

