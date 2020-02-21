//
//  ViewController.swift
//  CatchMooncake
//
//  Created by JanFranco on 27.01.2020.
//  Copyright © 2020 janfranco. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var game = false
    var screenX = 0, screenY = 0
    var timer = Timer(), timer2 = Timer()
    var x = 0, y = 0, score = 0, topScore = 0, count = 12
    var alert = UIAlertController(), okButton = UIAlertAction()
    
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var playButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let screenSize : CGRect = UIScreen.main.bounds
        screenX = Int(screenSize.maxX)
        screenY = Int(screenSize.maxY)
        
        if let topScoreFromUD = UserDefaults.standard.object(forKey: "top") as? Int {
            topScore = topScoreFromUD
        }
        
        scoreLabel.text = "Your Score: \(score) - Top Score: \(topScore)"
        
        image.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(updateScore))
        image.addGestureRecognizer(tapGesture)
        
        alert = UIAlertController(title: "Replay", message: "Tap replay button for replay the game", preferredStyle: UIAlertController.Style.alert)
        okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
        alert.addAction(okButton)
    }

    @IBAction func play(_ sender: Any) {
        playButton.isHidden = true
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateCount), userInfo: nil, repeats: true)
        timer2 = Timer.scheduledTimer(timeInterval: 0.4, target: self, selector: #selector(updateImg), userInfo: nil, repeats: true)
    }
    
    @objc func updateCount() {
        game = true
        count -= 1
        timeLabel.text = "Time left: \(count)"
        if count == 0 {
            game = false
            count = 12
            timer.invalidate()
            timer2.invalidate()
            timeLabel.text = "Time is up!"
            playButton.isHidden = false
            playButton.setTitle("Replay", for: .normal)
            if score > topScore {
                topScore = score
                scoreLabel.text = "Your Score: \(score) - Top Score: \(topScore)"
                UserDefaults.standard.set(topScore, forKey: "top")
            }
            score = 0
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    @objc func updateScore() {
        if game == true {
            score += 1
            scoreLabel.text = "Your Score: \(score) - Top Score: \(topScore)"
        }
    }
    
    @objc func updateImg() {
        let x = Int(arc4random_uniform(UInt32(screenX)))
        let y = Int(arc4random_uniform(UInt32(screenY)))
        var frame : CGRect = image.frame
        frame.origin.y = CGFloat(x)
        frame.origin.x = CGFloat(y)
        image.frame = frame
    }
    
}

