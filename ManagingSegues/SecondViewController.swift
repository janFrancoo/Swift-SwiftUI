//
//  SecondViewController.swift
//  SegueTutorial
//
//  Created by JanFranco on 26.01.2020.
//  Copyright © 2020 janfranco. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController {
    
    var name = ""
    @IBOutlet weak var label: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        label.text = name
    }

}
