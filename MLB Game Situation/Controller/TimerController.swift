//
//  TimerController.swift
//  MLB Game Situation
//
//  Created by Ramon Geronimo on 4/18/19.
//  Copyright © 2019 Ramon Geronimo. All rights reserved.



import Foundation
import UIKit

class TimerController: UIViewController {
    
    var seconds = 5 // starting value of seconds (should be above 0)
    var timer = Timer()
    var timeIsRunning = false // to make sure one timer is created at a time
    
    let timeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "HelveticaNeue-Bold", size: 25)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "5"
        label.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        label.textAlignment = .center
        label.backgroundColor = .red
        return label
    }()
    
    let startButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("start countdown", for: .normal)
        button.backgroundColor = .cyan
        button.setTitleColor(.black, for: .normal)
        button.addTarget(self, action: #selector(handleStartButton), for: .touchUpInside)
        return button
    }()
    
    @objc func handleStartButton() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: (#selector(TimerController.updateTimer)), userInfo: nil, repeats: true)
    }
    
    @objc func updateTimer() {
        
        timeIsRunning = true
        if timeIsRunning == true {
            seconds -= 1 // this will decrement (count down) the seconds
            timeLabel.text = "\(seconds)"
            
            if seconds == 0 {
                print("time!")
                seconds = 5
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "countStep"), object: nil)
//                timeIsRunning = false
//                timer.invalidate()
            }
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .brown
        
        view.addSubview(timeLabel)
        timeLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 50).isActive = true
        timeLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0).isActive = true
        timeLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0).isActive = true
        timeLabel.heightAnchor.constraint(equalToConstant: 100).isActive = true
        
        view.addSubview(startButton)
        startButton.topAnchor.constraint(equalTo: timeLabel.bottomAnchor, constant: 20).isActive = true
        startButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0).isActive = true
        startButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0).isActive = true
        startButton.heightAnchor.constraint(equalToConstant: 35).isActive = true
        
    }
}
