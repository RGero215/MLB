//
//  CardLauncher.swift
//  MLB Game Situation
//
//  Created by Ramon Geronimo on 3/21/19.
//  Copyright © 2019 Ramon Geronimo. All rights reserved.
//

import UIKit



class CardLauncher: UIViewController {
    
    var awayAbbr = ""
    var homeAbbr = ""
    var awayRuns = 0
    var homeRuns = 0
    var innings: [Inning] = []
    var inningCount: Int = 0
    var counts: [Count] = []
    var count: Count?
    var hitter: Hitter?
    var pitchCount: Int = 0
    
    var currentView: UIView?
    
    var pitchByPitch: PitchByPitch!
    
    weak var delegate: HomeControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()


    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    
        showCard()
    }
    
    func showCard() {
        print("Showing card...")
//        awayAbbr = (pitchByPitch?.scoring.away.abbr)!
        delegate?.loadPlays()
        guard let pitchByPitch = pitchByPitch else {return}
        guard let awayAbbr = pitchByPitch.scoring.away.abbr else {return}
        guard let homeAbbr = pitchByPitch.scoring.home.abbr else {return}
//        guard let awayRuns = pitchByPitch.scoring.away.abbr else {return}
        guard let homeRuns = pitchByPitch.scoring.home.runs else {return}
        
        self.innings = pitchByPitch.innings
        
        self.awayAbbr = awayAbbr
        self.homeAbbr = homeAbbr
        self.homeRuns = Int(homeRuns)!
        
        inning(innings: self.innings, number: 1)
        pitchCounter(pitchCount: 1)
        
//        guard let keyWindow = UIApplication.shared.keyWindow else {return}
//        let view = UIView(frame: keyWindow.frame)
        
        view.backgroundColor = UIColor.white
//        view.frame = CGRect(x: keyWindow.frame.width - 10, y: keyWindow.frame.height - 10, width: 10, height: 10)
        
        // status bar
        let statusBarBackgroundView = UIView()
        statusBarBackgroundView.backgroundColor = UIColor.black
        
        view.addSubview(statusBarBackgroundView)
        view.addConstraintsWithFormat(format: "H:|[v0]|", views: statusBarBackgroundView)
        view.addConstraintsWithFormat(format: "V:|[v0(40)]", views: statusBarBackgroundView)
        
        // scoreboard view
        let scoreboardFrame = CGRect(x: 0, y: 0, width: view.frame.width, height: 100)
        let scoreboardView = ScoreboardView(frame: scoreboardFrame)
        
        // set Scoreboard View
        setUpScoreboard(scoreboardView: scoreboardView)
        view.addSubview(scoreboardView)
        view.addConstraintsWithFormat(format: "H:|[v0]|", views: scoreboardView)
        view.addConstraintsWithFormat(format: "V:|[v0]-0-[v1(100)]", views: statusBarBackgroundView, scoreboardView)
        
        // Notify dismiss
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.dismissView), name: NSNotification.Name(rawValue: "dismissView"), object: nil)
        
        
        setUpHitter(scoreboardView: scoreboardView, view: view)
        
//        currentView = removingView(view: view)
        
//        keyWindow.addSubview(view)
//        view.frame = keyWindow.frame
//
//        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
//            view.frame = keyWindow.frame
//        }) { (completedAnimation) in
//            print("completed")
//
//        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        for subview in self.view.subviews {
            subview.removeFromSuperview()
        }
    }
    
//    func removingView(view: UIView) -> UIView {
//        return view
//    }
    
    @objc func dismissView() {
        print("Dismiss...")

        dismiss(animated: true, completion: nil)
    
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
            label.text = "\u{25B3} \(inningCount)"
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
            guard let count = self.count else {return label}
            label.text = "\(count.balls)-\(count.strikes)"
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
            guard let number = self.hitter?.jersey_number else {return label}
            guard let firstName = self.hitter?.first_name else {return label}
            guard let lastName = self.hitter?.last_name else {return label}
            label.text = "#\(number) \(firstName) \(lastName)"
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
    
    
    
    func setupPitchesButtons(view: UIView, stadium: UIImageView){
        
        let fastball: UIButton = {
            let button = UIButton(type: .system)
            button.setTitle("Fastball", for: .normal)
            button.setTitleColor(.white, for: .normal)
            button.backgroundColor = .blue
            button.titleLabel?.font = .systemFont(ofSize: 20)
            button.addTarget(self, action: #selector(handleFastball), for: .touchUpInside)
            
            return button
        }()
      
        let curveBall: UIButton = {
            let button = UIButton(type: .system)
            button.setTitle("CurveBall", for: .normal)
            button.setTitleColor(.blue, for: .normal)
            button.backgroundColor = .white
            button.layer.borderWidth = 1
            button.titleLabel?.font = .systemFont(ofSize: 20)
            button.addTarget(self, action: #selector(handleCurveBall), for: .touchUpInside)
            button.layer.borderColor = UIColor.blue.cgColor
            
            return button
        }()
        
        let slider: UIButton = {
            let button = UIButton()
            button.setTitle("Slider", for: .normal)
            button.setTitleColor(.white, for: .normal)
            button.backgroundColor = .blue
            button.titleLabel?.font = .systemFont(ofSize: 20)
            button.addTarget(self, action: #selector(handleSlider), for: .touchUpInside)
            
            return button
        }()
        
        let cutter: UIButton = {
            let button = UIButton()
            button.setTitle("Cutter", for: .normal)
            button.setTitleColor(.blue, for: .normal)
            button.backgroundColor = .white
            button.layer.borderWidth = 1
            button.layer.borderColor = UIColor.blue.cgColor
            button.titleLabel?.font = .systemFont(ofSize: 20)
            button.addTarget(self, action: #selector(handleCutter), for: .touchUpInside)
            
            return button
        }()
        
        let changeUp: UIButton = {
            let button = UIButton()
            button.setTitle("Change Up", for: .normal)
            button.setTitleColor(.white, for: .normal)
            button.backgroundColor = .blue
            button.titleLabel?.font = .systemFont(ofSize: 20)
            button.addTarget(self, action: #selector(handleChangeUp), for: .touchUpInside)
            
            return button
        }()
        
        let knuckleBall: UIButton = {
            let button = UIButton()
            button.setTitle("Knuckleball", for: .normal)
            button.setTitleColor(.blue, for: .normal)
            button.backgroundColor = .white
            button.layer.borderWidth = 1
            button.layer.borderColor = UIColor.blue.cgColor
            button.titleLabel?.font = .systemFont(ofSize: 20)
            button.addTarget(self, action: #selector(handleKnuckleball), for: .touchUpInside)
            
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
    
    @objc func handleCurveBall(sender: UIButton) {
        print("CurveBall...")
        
    }
    
    @objc func handleSlider(sender: UIButton) {
        print("Slider...")
        
    }
    
    @objc func handleCutter(sender: UIButton) {
        print("Cutter...")
        
    }
    
    @objc func handleChangeUp(sender: UIButton) {
        print("ChangeUp...")
        
    }
    
    @objc func handleKnuckleball(sender: UIButton) {
        print("Knuckleball...")
        
    }
    
    func inning(innings: [Inning], number: Int)  {
        for inning in innings {
            if inning.number == 0 {
                for player in inning.halfs[0].events {
                    print("#\(player.lineup?.jersey_number) \(player.lineup?.first_name) \(player.lineup?.last_name)")
                }
            } else if inning.number == 1 {
                if inning.halfs[0].events.count > 0 {
                    self.hitter = inning.halfs[0].events[0].at_bat?.hitter
                } else {
                    self.hitter = nil
                }
                for at_bat in inning.halfs[0].events {
                    guard let at_bat_events = at_bat.at_bat?.events else {return}
                    for at_bat_event in  at_bat_events {
                        guard let count = at_bat_event.count else {return}
                        self.inningCount = inning.number
                        self.counts.append(count)
                    }
                }
            }
        }
    }
    
    func pitchCounter(pitchCount: Int){
        for count in counts {
            if count.pitch_count == pitchCount {
                self.count = count
            }
        }
    }
    
    
}
