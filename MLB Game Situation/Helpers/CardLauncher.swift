//
//  CardLauncher.swift
//  MLB Game Situation
//
//  Created by Ramon Geronimo on 3/21/19.
//  Copyright © 2019 Ramon Geronimo. All rights reserved.
//

import UIKit



class CardLauncher: UIViewController {
    
    var step = Int()
    var countStep = Int()
    var runnersImage = ""
    
    var awayAbbr = ""
    var homeAbbr = ""
    var homeTeamName = ""
    var awayTeamName = ""
    var awayRuns = 0
    var homeRuns = 0
    var innings: [Inning] = []
    var inningCount: Int = 1
    var counts: [Count] = []
    var count: Count?
    var hitter: Hitter?
    var pitchCount: Int = 0
    var topEvents: [Event] = []
    var atBats: [At_Bat] = []
    var atBatEvent: [At_Bat_Event] = []
    
    
    var atBatsEvent: [Event]?
    var onBase: [Runner] = []
    
    var currentView: UIView?
    
    var pitchByPitch: PitchByPitch!
    
    weak var delegate: HomeControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        NotificationCenter.default.addObserver(self, selector: #selector(handleStep), name: NSNotification.Name(rawValue: "step"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleCount), name: NSNotification.Name(rawValue: "countStep"), object: nil)
        
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
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
        
        awayTeamName = pitchByPitch.scoring.away.name
        homeTeamName = pitchByPitch.scoring.home.name
        
        
        
//        guard let awayRuns = pitchByPitch.scoring.away.abbr else {return}
        guard let homeRuns = pitchByPitch.scoring.home.runs else {return}
        
        self.innings = pitchByPitch.innings
        
        self.awayAbbr = awayAbbr
        self.homeAbbr = homeAbbr
        self.homeRuns = Int(homeRuns)!
        
        inning(innings: self.innings, number: inningCount)
        pitchCounter(pitchCount: 1)
        manOnBases()
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.statusBarBackgroundView.backgroundColor = .black
        
//        guard let keyWindow = UIApplication.shared.keyWindow else {return}
//        keyWindow.window.
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
        

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        for subview in self.view.subviews {
            subview.removeFromSuperview()
        }
    }
    
    
    @objc func dismissView() {
        print("Dismiss...")

        dismiss(animated: true) {
            self.awayRuns = 0
            self.inningCount = 1
            self.step = 0
            self.countStep = 0
            self.innings = []
            self.counts = []
            self.onBase = []
            self.inning(innings: self.innings, number: self.inningCount)
            self.diamondView.image = UIImage(named: "empty_bases")
            self.outsView.image = UIImage(named: "no_out")
            self.countLabel.text = "\(0)-\(0)"
            self.awayLabel.text = "\(self.awayAbbr): \(self.awayRuns)"
            self.inningLabel.text = "\u{25B3} \(self.inningCount)"
            self.atBatEvent = []
            self.atBats = []
            self.topEvents = []
            
            print("""
                
                
                
                AT BAT EVENT Dismiss: \(self.atBatEvent.count)
                
                
                
                """)
            
        }
    
    }
    
    lazy var diamondView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = bases(runner: runnersImage)
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        return imageView
    }()
    
    // Away
    lazy var awayLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "\(awayAbbr): \(awayRuns)"
        label.textColor = .white
        label.backgroundColor = awayColor(teamName: awayTeamName)
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textAlignment = .center
        return label
    }()
    
    lazy var countLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textAlignment = .center
        label.text = "\(0)-\(0)"
        return label
    }()
    
    lazy var outsView: UIImageView = {
        let imageView = UIImageView()
        guard let count = self.count else {return imageView}
        imageView.image = UIImage(named: "no_outs")
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        return imageView
    }()
    
    lazy var inningLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "\u{25B3} \(inningCount)"
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textAlignment = .center
        return label
    }()
    
    func setUpScoreboard(scoreboardView: UIView){
        awayLabel.text = "\(awayAbbr): \(awayRuns)"
        awayLabel.backgroundColor = awayColor(teamName: awayTeamName)
        print("""
            
            

            AT BAT EVENT SET UP: \(atBatEvent.count)
            
            
            
            """)
        if self.innings[1].halfs[0].events.count > 0 {
            if let number = atBatEvent[countStep].hitter?.jersey_number, let firstName = atBatEvent[countStep].hitter?.first_name, let lastName = atBatEvent[countStep].hitter?.last_name {
                hitterLabel.text = "#\(number) \(firstName) \(lastName)"
            } else {
                guard let firstName = atBatEvent[countStep].hitter?.first_name else  {return}
                guard let lastName = atBatEvent[countStep].hitter?.last_name else {return}
                hitterLabel.text = "\(firstName) \(lastName)"
            }
            
        } else {
            self.hitter = Hitter(preferred_name: "", first_name: "NO", last_name: "DATA", jersey_number: "0", id: "00000")
            guard let number = hitter?.jersey_number else {return}
            guard let firstName = hitter?.first_name else {return}
            guard let lastName = hitter?.last_name else {return}
            
            hitterLabel.text = "#\(number) \(firstName) \(lastName)"
        }
        
        
        hitterLabel.backgroundColor = awayColor(teamName: awayTeamName)
        
        let homeLabel: UILabel = {
            let label = UILabel()
            label.translatesAutoresizingMaskIntoConstraints = false
            label.text = "\(homeAbbr): \(homeRuns)"
            label.textColor = .white
            label.backgroundColor = homeColor(teamName: homeTeamName)
            label.font = UIFont.boldSystemFont(ofSize: 20)
            label.textAlignment = .center
            return label
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
        
        
        
        let countTitleLabel: UILabel = {
            let label = UILabel()
            label.translatesAutoresizingMaskIntoConstraints = false
            label.text = "Count"
            label.textColor = .white
            label.font = UIFont.boldSystemFont(ofSize: 20)
            label.textAlignment = .center
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
    
    lazy var hitterLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.backgroundColor = awayColor(teamName: awayTeamName)
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textAlignment = .center
        if let number = atBatEvent[countStep].hitter?.jersey_number, let firstName = atBatEvent[countStep].hitter?.first_name, let lastName = atBatEvent[countStep].hitter?.last_name {
            label.text = "#\(number) \(firstName) \(lastName)"
        } else {
            guard let firstName = atBatEvent[countStep].hitter?.first_name else  {return label}
            guard let lastName = atBatEvent[countStep].hitter?.last_name else {return label}
            label.text = "\(firstName) \(lastName)"
        }
        return label
    }()
    
    lazy var hittingPositionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "1"
        label.textColor = .white
        label.backgroundColor = .black
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textAlignment = .center
        return label
    }()
    
    func setUpHitter(scoreboardView: UIView, view: UIView) {
        
        
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
            button.backgroundColor = homeColor(teamName: homeTeamName)
            button.titleLabel?.font = .systemFont(ofSize: 20)
            button.addTarget(self, action: #selector(handleFastball), for: .touchUpInside)
            
            return button
        }()
      
        let curveBall: UIButton = {
            let button = UIButton(type: .system)
            button.setTitle("CurveBall", for: .normal)
            button.setTitleColor(homeColor(teamName: homeTeamName), for: .normal)
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
            button.backgroundColor = homeColor(teamName: homeTeamName)
            button.titleLabel?.font = .systemFont(ofSize: 20)
            button.addTarget(self, action: #selector(handleSlider), for: .touchUpInside)
            
            return button
        }()
        
        let cutter: UIButton = {
            let button = UIButton()
            button.setTitle("Cutter", for: .normal)
            button.setTitleColor(homeColor(teamName: homeTeamName), for: .normal)
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
            button.backgroundColor = homeColor(teamName: homeTeamName)
            button.titleLabel?.font = .systemFont(ofSize: 20)
            button.addTarget(self, action: #selector(handleChangeUp), for: .touchUpInside)
            
            return button
        }()
        
        let knuckleBall: UIButton = {
            let button = UIButton()
            button.setTitle("Knuckleball", for: .normal)
            button.setTitleColor(homeColor(teamName: homeTeamName), for: .normal)
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
        step += 1
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "step"), object: nil)
        diamondView.image = bases(runner: runnersImage)
        print("Steps: \(step)")
    
    }
    
    @objc func handleCurveBall(sender: UIButton) {
        print("CurveBall...")
        countStep += 1
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "countStep"), object: nil)
        
        
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
    
    var flags: [Flags] = []
    
    func inning(innings: [Inning], number: Int)  {
        for inning in innings {
            if inning.number == 0 {
                for player in inning.halfs[0].events {
                    print("#\(player.lineup?.jersey_number) \(player.lineup?.first_name) \(player.lineup?.last_name)")
                }
            } else if inning.number == number {
                topHalfEvents(inning: inning, number: inning.number)
                atBats(topEvents: topEvents)
                atBatEvents(atbats: atBats)
                getAtBatEvent(atBatEvent: atBatEvent)
                
                

            }
//            else if inning.number == number {
//                if inning.halfs[0].events.count > 0 {
//                    self.hitter = inning.halfs[0].events[0].at_bat?.hitter
//                } else {
//                    self.hitter = Hitter(preferred_name: "", first_name: "NO", last_name: "DATA", jersey_number: "0", id: "00000")
//                }
//                for at_bat in inning.halfs[0].events {
//                    guard let at_bat_events = at_bat.at_bat?.events else {return}
//                    for at_bat_event in  at_bat_events {
//                        guard let count = at_bat_event.count else {return}
//
//                        self.counts.append(count)
//
//                    }
//                }
//            }
        }
    }
    
    func topHalfEvents(inning: Inning, number: Int) {
        for event in inning.halfs[0].events {
            self.topEvents.append(event)
        }
//        self.topEvents = inning.halfs.map {$0.events.map {$0.at_bat.}}
    }
    
    func atBats(topEvents: [Event]) {
        for event in topEvents {
            guard let atbat = event.at_bat else {return}
            self.atBats.append(atbat)
        }
    }
    
    func atBatEvents(atbats: [At_Bat] ){

        self.atBatEvent = atBats.flatMap {$0.events}
    
    }
    
    func getAtBatEvent(atBatEvent: [At_Bat_Event]){
        
        
        self.counts = atBatEvent.compactMap {$0.count}
        self.flags = atBatEvent.compactMap {$0.flags}
        
        
        
        for event in atBatEvent {
            guard let count = event.count else {return}
            guard let flags = event.flags else {return}
            
            
            
            print("""
                
                Count \(self.counts.count): \(count)
                flags \(self.flags.count): \(flags)
                
                
                
                
                Balls \(self.counts.count): \(count.balls)
                Strikes \(self.counts.count): \(count.strikes)
                OUTs \(self.counts.count): \(count.outs)
                Pitch Count \(self.counts.count): \(count.pitch_count)
                
                
                """)
        }
    }
    
   
    
    func pitchCounter(pitchCount: Int){
        for count in counts {
            if count.pitch_count == pitchCount {
                self.count = count
            }
        }
    }
    
    
    @objc func handleCount() {
       
        countStepper(count: counts, flags: flags, step: countStep)
       
    }
    
    func countStepper(count: [Count], flags: [Flags], step: Int) {
        guard let number = atBatEvent[countStep].hitter?.jersey_number else {return}
        guard let firstName = atBatEvent[countStep].hitter?.first_name else {return}
        guard let lastName = atBatEvent[countStep].hitter?.last_name else {return }
        
        self.hitterLabel.text = "#\(number) \(firstName) \(lastName)"
        
        print("""
            
            Count \(count.count): \(count)
            
            
            
            
            Balls \(step - 1): \(count[step - 1].balls)
            Strikes \(step - 1): \(count[step - 1].strikes)
            OUTs \(step - 1): \(count[step - 1].outs)
            Pitch Count \(step - 1): \(count[step - 1].pitch_count)
            
            
            """)
        if count[step - 1].outs == 0 {
            outsView.image = outs(manyOuts: count[step - 1].outs)
            if flags[step - 1].is_ab_over || flags[step - 1].is_hit {
                countLabel.text = "\(0)-\(0)"
                self.hitterLabel.text = "#\(number) \(firstName) \(lastName)"
                
            } else {
                countLabel.text = "\(count[step - 1].balls)-\(count[step - 1].strikes)"
            }
            
        } else if count[step - 1].outs == 1 {
            outsView.image = outs(manyOuts: count[step - 1].outs)
            if flags[step - 1].is_ab_over || flags[step - 1].is_hit {
                countLabel.text = "\(0)-\(0)"
            } else {
                countLabel.text = "\(count[step - 1].balls)-\(count[step - 1].strikes)"
            }
            
        } else if count[step - 1].outs == 2 {
            outsView.image = outs(manyOuts: count[step - 1].outs)
            if flags[step - 1].is_ab_over || flags[step - 1].is_hit {
                countLabel.text = "\(0)-\(0)"
            } else {
                countLabel.text = "\(count[step - 1].balls)-\(count[step - 1].strikes)"
            }
        } else if count[step - 1].outs == 3 {
            outsView.image = outs(manyOuts: count[step - 1].outs)
            if flags[step - 1].is_ab_over || flags[step - 1].is_hit {
                countLabel.text = "\(0)-\(0)"
            } else {
                countLabel.text = "\(count[step - 1].balls)-\(count[step - 1].strikes)"
            }
            self.counts = []
            self.flags = []
            print("""
                
                Second Inning:
                
                Count \(count.count): \(count)
                
                
                
                Balls \(step - 1): \(count[step - 1].balls)
                Strikes \(step - 1): \(count[step - 1].strikes)
                OUTs \(step - 1): \(count[step - 1].outs)
                Pitch Count \(step - 1): \(count[step - 1].pitch_count)
                
                
                """)
            countStep = 0
            inningCount += 1
            inningLabel.text = "\u{25B3} \(inningCount)"
            inning(innings: innings, number: inningCount)
        }
        
        
    }
    
    var isOut = false
    
    @objc func handleResetCount() {
        isOut.toggle()
        self.countLabel.text = "\(0)-\(0)"
    }
    
    func manOnBases() {
        
        for event in atBatEvent {
            if (event.runners != nil) {
                for runner in event.runners! {
                    
                    onBase.append(runner)
                    
                }
            }
        }
        
        
        print("""
            
            ON BASE \(onBase.count): \(onBase)
            
            """)
        
    }
    
    
}
