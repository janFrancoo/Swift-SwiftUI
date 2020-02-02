//
//  ViewController.swift
//  TimerTutorial
//
//  Created by JanFranco on 26.01.2020.
//  Copyright © 2020 janfranco. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var count = 0
    var timer = Timer()
    @IBOutlet weak var label: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        count = 10
        label.text = "Time: \(count)"
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerFunc), userInfo: nil, repeats: true)
    }
    
    @objc func timerFunc() {
        label.text = "Time: \(count)"
        if count == 0 {
            label.text = "Time's over"
            timer.invalidate()
        }
        count -= 1
    }

    @IBAction func click(_ sender: Any) {
        print("Clicked")
    }
    
}

