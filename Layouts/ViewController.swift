//
//  ViewController.swift
//  Layouts
//
//  Created by JanFranco on 25.01.2020.
//  Copyright © 2020 janfranco. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var count = 0
    var myLabel = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let width = view.frame.size.width
        let height = view.frame.size.height

        myLabel.text = "JanFranco"
        myLabel.textAlignment = .center
        myLabel.frame = CGRect(x: width * 0.5 - width * 0.8 / 2,
                               y: height * 0.5 - 50 / 2,
                               width: width * 0.8,
                               height: 50)
        view.addSubview(myLabel)
        
        let myButton = UIButton()
        myButton.setTitle("MyButton", for: UIControl.State.normal)
        myButton.setTitleColor(UIColor.blue, for: UIControl.State.normal)
        myButton.frame = CGRect(x: width * 0.5 - 100,
                                y: height * 0.6 - 50,
                                width: 200, height: 100)
        view.addSubview(myButton)
        
        myButton.addTarget(self, action: #selector(self.myAction), for: UIControl.Event.touchUpInside)
        
    }
    
    @objc func myAction() {
        count += 1
        myLabel.text = String(count)
    }

}
