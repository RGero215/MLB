//
//  CardLauncher.swift
//  MLB Game Situation
//
//  Created by Ramon Geronimo on 3/21/19.
//  Copyright © 2019 Ramon Geronimo. All rights reserved.
//

import UIKit



class CardLauncher: NSObject {
    
    var awayAbbr = ""
    var homeAbbr = ""
    var awayRuns = 0
    var homeRuns = 0
    var innings: [Inning] = []
    
    
    var pitchByPitch: PitchByPitch!
    
    weak var delegate: HomeControllerDelegate?
    
    
    func showCard() {
        print("Showing card...")
//        awayAbbr = (pitchByPitch?.scoring.away.abbr)!
        delegate?.loadPlays()
        guard let awayAbbr = pitchByPitch.scoring.away.abbr else {return}
        guard let homeAbbr = pitchByPitch.scoring.home.abbr else {return}
//        guard let awayRuns = pitchByPitch.scoring.away.abbr else {return}
        guard let homeRuns = pitchByPitch.scoring.home.runs else {return}
        
        self.awayAbbr = awayAbbr
        self.homeAbbr = homeAbbr
        
        print("*************  Connected: \(pitchByPitch.scoring.home.abbr) ************")
        
        guard let keyWindow = UIApplication.shared.keyWindow else {return}
        let view = UIView(frame: keyWindow.frame)
        view.backgroundColor = UIColor.white
        view.frame = CGRect(x: keyWindow.frame.width - 10, y: keyWindow.frame.height - 10, width: 10, height: 10)
        
        // status bar
        let statusBarBackgroundView = UIView()
        statusBarBackgroundView.backgroundColor = UIColor.black
        
        view.addSubview(statusBarBackgroundView)
        view.addConstraintsWithFormat(format: "H:|[v0]|", views: statusBarBackgroundView)
        view.addConstraintsWithFormat(format: "V:|[v0(40)]", views: statusBarBackgroundView)
        
        // scoreboard view
        let scoreboardFrame = CGRect(x: 0, y: 0, width: keyWindow.frame.width, height: 100)
        let scoreboardView = ScoreboardView(frame: scoreboardFrame)
        view.addSubview(scoreboardView)
        view.addConstraintsWithFormat(format: "H:|[v0]|", views: scoreboardView)
        view.addConstraintsWithFormat(format: "V:|[v0]-0-[v1(100)]", views: statusBarBackgroundView, scoreboardView)
        
        setUpScoreboard(scoreboardView: scoreboardView)
        
        setUpHitter(scoreboardView: scoreboardView, view: view)
        
        
        
        keyWindow.addSubview(view)
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            view.frame = keyWindow.frame
        }) { (completedAnimation) in
            print("completed")
    
        }
    }
    
    func setUpScoreboard(scoreboardView: UIView){
        // Away
        let awayLabel: UILabel = {
            let label = UILabel()
            label.translatesAutoresizingMaskIntoConstraints = false
            label.text = "\(awayAbbr): \(awayRuns)"
            label.textColor = .white
            label.backgroundColor = .orange
            label.font = UIFont.boldSystemFont(ofSize: 20)
            label.textAlignment = .center
            return label
        }()
        
        let homeLabel: UILabel = {
            let label = UILabel()
            label.translatesAutoresizingMaskIntoConstraints = false
            label.text = "\(homeAbbr): \(homeRuns)"
            label.textColor = .white
            label.backgroundColor = .blue
            label.font = UIFont.boldSystemFont(ofSize: 20)
            label.textAlignment = .center
            return label
        }()
        
        let diamondView: UIImageView = {
            let imageView = UIImageView()
            imageView.image = UIImage(named: "diamond")
            imageView.contentMode = .scaleAspectFit
            imageView.clipsToBounds = true
            return imageView
        }()
        
        let inningTitleLabel: UILabel = {
            let label = UILabel()
            label.translatesAutoresizingMaskIntoConstraints = false
            label.text = "Inning"
            label.textColor = .white
            label.font = UIFont.boldSystemFont(ofSize: 20)
            label.textAlignment = .center
            return label
        }()
        
        let inningLabel: UILabel = {
            let label = UILabel()
            label.translatesAutoresizingMaskIntoConstraints = false
            label.text = "\u{25B3} 1"
            label.textColor = .white
            label.font = UIFont.boldSystemFont(ofSize: 20)
            label.textAlignment = .center
            return label
        }()
        
        let countTitleLabel: UILabel = {
            let label = UILabel()
            label.translatesAutoresizingMaskIntoConstraints = false
            label.text = "Count"
            label.textColor = .white
            label.font = UIFont.boldSystemFont(ofSize: 20)
            label.textAlignment = .center
            return label
        }()
        
        let countLabel: UILabel = {
            let label = UILabel()
            label.translatesAutoresizingMaskIntoConstraints = false
            label.textColor = .white
            label.font = UIFont.boldSystemFont(ofSize: 20)
            label.textAlignment = .center
            label.text = "1-2"
            return label
        }()
        
        let outsTitleLabel: UILabel = {
            let label = UILabel()
            label.translatesAutoresizingMaskIntoConstraints = false
            label.text = "Outs"
            label.textColor = .white
            label.font = UIFont.boldSystemFont(ofSize: 20)
            label.textAlignment = .center
            return label
        }()
        
        let outsView: UIImageView = {
            let imageView = UIImageView()
            imageView.image = UIImage(named: "outs")
            imageView.contentMode = .scaleAspectFit
            imageView.clipsToBounds = true
            return imageView
        }()
        
        scoreboardView.addSubview(awayLabel)
        scoreboardView.addConstraintsWithFormat(format: "H:|[v0(100)]", views: awayLabel)
        scoreboardView.addConstraintsWithFormat(format: "V:|[v0(50)]", views: awayLabel)
        
        scoreboardView.addSubview(homeLabel)
        scoreboardView.addConstraintsWithFormat(format: "H:|[v0(100)]", views: homeLabel)
        scoreboardView.addConstraintsWithFormat(format: "V:|[v0]-0-[v1]|", views: awayLabel, homeLabel)
        scoreboardView.addConstraintsWithFormat(format: "V:|[v0(50)]", views: awayLabel)
        
        scoreboardView.addSubview(inningTitleLabel)
        scoreboardView.addConstraintsWithFormat(format: "H:|[v0]-0-[v1(75)]", views: awayLabel, inningTitleLabel)
        scoreboardView.addConstraintsWithFormat(format: "V:|[v0(50)]", views: inningTitleLabel)
        
        scoreboardView.addSubview(inningLabel)
        scoreboardView.addConstraintsWithFormat(format: "H:|[v0]-0-[v1(75)]", views: homeLabel, inningLabel)
        scoreboardView.addConstraintsWithFormat(format: "V:|[v0]-0-[v1]|", views: inningTitleLabel, inningLabel)
        
        scoreboardView.addSubview(outsTitleLabel)
        scoreboardView.addConstraintsWithFormat(format: "H:[v0]-0-[v1(75)]", views: inningTitleLabel, outsTitleLabel)
        scoreboardView.addConstraintsWithFormat(format: "V:|[v0(50)]", views: outsTitleLabel)
        
        scoreboardView.addSubview(outsView)
        scoreboardView.addConstraintsWithFormat(format: "H:[v0]-0-[v1(75)]", views: inningLabel, outsView)
        scoreboardView.addConstraintsWithFormat(format: "V:|[v0]-0-[v1]|", views: outsTitleLabel, outsView)
        
        scoreboardView.addSubview(countTitleLabel)
        scoreboardView.addConstraintsWithFormat(format: "H:[v0]-0-[v1(75)]", views: outsTitleLabel, countTitleLabel)
        scoreboardView.addConstraintsWithFormat(format: "V:|[v0(50)]", views: countTitleLabel)
        
        scoreboardView.addSubview(countLabel)
        scoreboardView.addConstraintsWithFormat(format: "H:[v0]-0-[v1(75)]", views: outsView, countLabel)
        scoreboardView.addConstraintsWithFormat(format: "V:|[v0]-0-[v1]|", views: countTitleLabel, countLabel)
        
        scoreboardView.addSubview(diamondView)
        scoreboardView.addConstraintsWithFormat(format: "H:[v0]-0-[v1(75)]|", views: outsView, diamondView)
        scoreboardView.addConstraintsWithFormat(format: "V:|[v0]|", views: diamondView)
        
    }
    
    func setUpHitter(scoreboardView: UIView, view: UIView) {
        let hitterLabel: UILabel = {
            let label = UILabel()
            label.translatesAutoresizingMaskIntoConstraints = false
            label.text = "#24 Robinson Cano"
            label.textColor = .white
            label.backgroundColor = .orange
            label.font = UIFont.boldSystemFont(ofSize: 20)
            label.textAlignment = .center
            return label
        }()
        
        let hittingPositionLabel: UILabel = {
            let label = UILabel()
            label.translatesAutoresizingMaskIntoConstraints = false
            label.text = "1"
            label.textColor = .white
            label.backgroundColor = .black
            label.font = UIFont.boldSystemFont(ofSize: 20)
            label.textAlignment = .center
            return label
        }()
        
        scoreboardView.addSubview(hittingPositionLabel)
        scoreboardView.addConstraintsWithFormat(format: "V:[v0]-0-[v1(50)]", views: scoreboardView, hittingPositionLabel)
        
        scoreboardView.addSubview(hitterLabel)
        scoreboardView.addConstraintsWithFormat(format: "H:|[v0(50)]-0-[v1]|", views: hittingPositionLabel, hitterLabel)
        scoreboardView.addConstraintsWithFormat(format: "V:[v0]-0-[v1(50)]", views: scoreboardView, hitterLabel)
        
        setupStadium(view: view, hitterLabel: hitterLabel)
        

    }
    
    func setupStadium(view: UIView, hitterLabel: UILabel){
        let stadiumView: UIImageView = {
            let imageView = UIImageView()
            imageView.image = UIImage(named: "rising2dtop stadium")
            imageView.contentMode = .scaleAspectFill
            imageView.clipsToBounds = true
            return imageView
        }()
        
        view.addSubview(stadiumView)
        view.addConstraintsWithFormat(format: "H:|[v0]|", views: stadiumView)
        view.addConstraintsWithFormat(format: "V:[v0]-0-[v1(400)]", views: hitterLabel, stadiumView)
        
        setupPitchesButtons(view: view, stadium: stadiumView)
    }
    
    lazy var fastball: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Fastball", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .blue
        button.addTarget(self, action: #selector(handleFastball), for: .touchUpInside)
        
        return button
    }()
    
    func setupPitchesButtons(view: UIView, stadium: UIImageView){
      
        let curveBall: UIButton = {
            let button = UIButton()
            button.setTitle("CurveBall", for: .normal)
            button.setTitleColor(.blue, for: .normal)
            button.backgroundColor = .white
            button.layer.borderWidth = 1
            button.layer.borderColor = UIColor.blue.cgColor
            
            return button
        }()
        
        let slider: UIButton = {
            let button = UIButton()
            button.setTitle("Slider", for: .normal)
            button.setTitleColor(.white, for: .normal)
            button.backgroundColor = .blue
            
            return button
        }()
        
        let cutter: UIButton = {
            let button = UIButton()
            button.setTitle("Cutter", for: .normal)
            button.setTitleColor(.blue, for: .normal)
            button.backgroundColor = .white
            button.layer.borderWidth = 1
            button.layer.borderColor = UIColor.blue.cgColor
            
            return button
        }()
        
        let changeUp: UIButton = {
            let button = UIButton()
            button.setTitle("Change Up", for: .normal)
            button.setTitleColor(.white, for: .normal)
            button.backgroundColor = .blue
            
            return button
        }()
        
        let knuckleBall: UIButton = {
            let button = UIButton()
            button.setTitle("Knuckleball", for: .normal)
            button.setTitleColor(.blue, for: .normal)
            button.backgroundColor = .white
            button.layer.borderWidth = 1
            button.layer.borderColor = UIColor.blue.cgColor
            
            return button
        }()
        
        view.addSubview(fastball)
        view.addConstraintsWithFormat(format: "H:|[v0]|", views: fastball)
        view.addConstraintsWithFormat(format: "V:[v0]-0-[v1(50)]", views: stadium, fastball)
        
        view.addSubview(curveBall)
        view.addConstraintsWithFormat(format: "H:|[v0]|", views: curveBall)
        view.addConstraintsWithFormat(format: "V:[v0]-0-[v1(50)]", views: fastball, curveBall)
        
        view.addSubview(slider)
        view.addConstraintsWithFormat(format: "H:|[v0]|", views: slider)
        view.addConstraintsWithFormat(format: "V:[v0]-0-[v1(50)]", views: curveBall, slider)
        
        view.addSubview(cutter)
        view.addConstraintsWithFormat(format: "H:|[v0]|", views: cutter)
        view.addConstraintsWithFormat(format: "V:[v0]-0-[v1(50)]", views: slider, cutter)
        
        view.addSubview(changeUp)
        view.addConstraintsWithFormat(format: "H:|[v0]|", views: changeUp)
        view.addConstraintsWithFormat(format: "V:[v0]-0-[v1(50)]", views: cutter, changeUp)
        
        view.addSubview(knuckleBall)
        view.addConstraintsWithFormat(format: "H:|[v0]|", views: knuckleBall)
        view.addConstraintsWithFormat(format: "V:[v0]-0-[v1(50)]", views: changeUp, knuckleBall)
    }
    
    @objc func handleFastball(sender: UIButton) {
        print("Fastball...")
    
    }
    
    
}
