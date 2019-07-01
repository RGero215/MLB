//
//  CardLauncher.swift
//  MLB Game Situation
//
//  Created by Ramon Geronimo on 3/21/19.
//  Copyright © 2019 Ramon Geronimo. All rights reserved.
//

import UIKit



class CardLauncher: UIViewController {
    var tempo = TimerController()
    
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
    var hitterCounter: Int = 0
    var atBatEventsCounter: Int = 0
    var type: [String] = []
    
    
    
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
//        delegate?.loadPlays()
        guard let pitchByPitch = pitchByPitch else {return}
        
        guard let awayAbbr = pitchByPitch.scoring.away.abbr else {return}
        guard let homeAbbr = pitchByPitch.scoring.home.abbr else {return}
        
        awayTeamName = pitchByPitch.scoring.away.name
        homeTeamName = pitchByPitch.scoring.home.name
        
        
        
//        guard let awayRuns = pitchByPitch.scoring.away.abbr else {return}
        guard let homeRuns = pitchByPitch.scoring.home.runs else {return}
        
        self.innings = pitchByPitch.innings
        
        if self.innings[1].halfs[0].events.count > 0 {
            tempo.handleStartButton()
        }
        
        self.awayAbbr = awayAbbr
        self.homeAbbr = homeAbbr
        self.homeRuns = Int(homeRuns)!
        
        inning(innings: self.innings, number: inningCount)
        pitchCounter(pitchCount: 1)
        manOnBases()
        
        print("""
            
            
            
            Home Team: \(homeAbbr) \(homeRuns)
            
            
            
            """)
        
        view.backgroundColor = UIColor.black
       
        
        // scoreboard view
        let scoreboardFrame = CGRect(x: 0, y: 0, width: view.frame.width, height: 100)
        let scoreboardView = ScoreboardView(frame: scoreboardFrame)
        scoreboardView.translatesAutoresizingMaskIntoConstraints = false
        
        // set Scoreboard View
        setUpScoreboard(scoreboardView: scoreboardView)
        view.addSubview(scoreboardView)
        scoreboardView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0).isActive = true
        scoreboardView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
        scoreboardView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0).isActive = true
        
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
            self.type = []
            self.onBase = []
            self.inning(innings: self.innings, number: self.inningCount)
            self.diamondView.image = UIImage(named: "empty_bases")
            self.outsView.image = UIImage(named: "no_outs")
            self.countLabel.text = "\(0)-\(0)"
            self.awayLabel.text = "\(self.awayAbbr): \(self.awayRuns)"
            self.homeLabel.text = "\(self.homeAbbr): \(self.homeRuns)"
            self.inningLabel.text = "\u{25B3} \(self.inningCount)"
            self.atBatEvent = []
            self.atBats = []
            self.topEvents = []
            self.tempo.timeIsRunning = false
            self.tempo.timer.invalidate()
            self.tempo.seconds = 5
            self.tempo.timeLabel.text = "5"
            
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
    
    lazy var homeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "\(homeAbbr): \(homeRuns)"
        label.textColor = .white
        label.backgroundColor = homeColor(teamName: homeTeamName)
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
    
    lazy var inningTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Inning"
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textAlignment = .center
        return label
    }()
    
    lazy var countTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Count"
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textAlignment = .center
        return label
    }()
    
    
    
    lazy var outsTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Outs"
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textAlignment = .center
        return label
    }()
    
    lazy var scoreboardStackView = UIStackView()
    lazy var teamsStackView = UIStackView()
    lazy var inningStackView = UIStackView()
    lazy var outStackView = UIStackView()
    lazy var countStackView = UIStackView()
    lazy var runnerStackView = UIStackView()
    
    func setUpScoreboard(scoreboardView: UIView){
        awayLabel.text = "\(awayAbbr): \(awayRuns)"
        awayLabel.backgroundColor = awayColor(teamName: awayTeamName)
        homeLabel.text = "\(homeAbbr): \(homeRuns)"
        homeLabel.backgroundColor = homeColor(teamName: homeTeamName)
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
        
        
        scoreboardStackView = UIStackView(arrangedSubviews: [teamsStackView, inningStackView, outStackView, countStackView, runnerStackView])
        scoreboardView.addSubview(scoreboardStackView)
        scoreboardStackView.axis = .horizontal
        scoreboardStackView.spacing = 0
        scoreboardStackView.distribution = .fillEqually
        scoreboardStackView.topAnchor.constraint(equalTo: scoreboardView.topAnchor, constant: 0).isActive = true
        scoreboardStackView.leadingAnchor.constraint(equalTo: scoreboardView.leadingAnchor, constant: 0).isActive = true
        scoreboardStackView.trailingAnchor.constraint(equalTo: scoreboardView.trailingAnchor, constant: -20).isActive = true
        scoreboardStackView.bottomAnchor.constraint(equalTo: scoreboardView.bottomAnchor, constant: 0).isActive = true
        scoreboardStackView.translatesAutoresizingMaskIntoConstraints = false
        
        teamsStackView = UIStackView(arrangedSubviews: [awayLabel, homeLabel])
        scoreboardStackView.addSubview(teamsStackView)
        teamsStackView.axis = .vertical
        teamsStackView.spacing = 0
        teamsStackView.distribution = .fillEqually
        teamsStackView.topAnchor.constraint(equalTo: scoreboardStackView.topAnchor, constant: 0).isActive = true
        teamsStackView.leadingAnchor.constraint(equalTo: scoreboardStackView.leadingAnchor, constant: 0).isActive = true
        teamsStackView.bottomAnchor.constraint(equalTo: scoreboardStackView.bottomAnchor, constant: 0).isActive = true
        teamsStackView.translatesAutoresizingMaskIntoConstraints = false
        teamsStackView.widthAnchor.constraint(equalToConstant: CGFloat(80)).isActive = true
        
        inningStackView = UIStackView(arrangedSubviews: [inningTitleLabel, inningLabel])
        scoreboardStackView.addSubview(inningStackView)
        inningStackView.axis = .vertical
        inningStackView.spacing = 0
        inningStackView.distribution = .fillEqually
        inningStackView.topAnchor.constraint(equalTo: scoreboardStackView.topAnchor, constant: 0).isActive = true
        inningStackView.leadingAnchor.constraint(equalTo: teamsStackView.trailingAnchor, constant: 5).isActive = true
        inningStackView.bottomAnchor.constraint(equalTo: scoreboardStackView.bottomAnchor, constant: 0).isActive = true
        inningStackView.translatesAutoresizingMaskIntoConstraints = false
        inningStackView.widthAnchor.constraint(equalToConstant: CGFloat(60)).isActive = true

        outStackView = UIStackView(arrangedSubviews: [outsTitleLabel, outsView])
        scoreboardStackView.addSubview(outStackView)
        outStackView.axis = .vertical
        outStackView.spacing = 0
        outStackView.distribution = .fillEqually
        outStackView.topAnchor.constraint(equalTo: scoreboardStackView.topAnchor, constant: 0).isActive = true
        outStackView.leadingAnchor.constraint(equalTo: inningStackView.trailingAnchor, constant: 5).isActive = true
        outStackView.bottomAnchor.constraint(equalTo: scoreboardStackView.bottomAnchor, constant: 0).isActive = true
        outStackView.translatesAutoresizingMaskIntoConstraints = false
        outsView.heightAnchor.constraint(equalToConstant: CGFloat(20)).isActive = true
        outsView.widthAnchor.constraint(equalToConstant: CGFloat(20)).isActive = true
        outStackView.widthAnchor.constraint(equalToConstant: CGFloat(60)).isActive = true
        
        countStackView = UIStackView(arrangedSubviews: [countTitleLabel, countLabel])
        scoreboardStackView.addSubview(countStackView)
        countStackView.axis = .vertical
        countStackView.spacing = 0
        countStackView.distribution = .fillEqually
        countStackView.topAnchor.constraint(equalTo: scoreboardStackView.topAnchor, constant: 0).isActive = true
        countStackView.leadingAnchor.constraint(equalTo: outStackView.trailingAnchor, constant: 5).isActive = true
        countStackView.bottomAnchor.constraint(equalTo: scoreboardStackView.bottomAnchor, constant: 0).isActive = true
        countStackView.translatesAutoresizingMaskIntoConstraints = false
        countStackView.widthAnchor.constraint(equalToConstant: CGFloat(60)).isActive = true
//
        runnerStackView = UIStackView(arrangedSubviews: [diamondView])
        scoreboardStackView.addSubview(runnerStackView)
        runnerStackView.axis = .vertical
        runnerStackView.spacing = 0
        runnerStackView.distribution = .fillEqually
        runnerStackView.topAnchor.constraint(equalTo: scoreboardStackView.topAnchor, constant: 0).isActive = true
        runnerStackView.leadingAnchor.constraint(equalTo: countStackView.trailingAnchor, constant: 0).isActive = true
        runnerStackView.bottomAnchor.constraint(equalTo: scoreboardStackView.bottomAnchor, constant: 0).isActive = true
        runnerStackView.trailingAnchor.constraint(equalTo: scoreboardStackView.trailingAnchor, constant: 0).isActive = true
        
        runnerStackView.translatesAutoresizingMaskIntoConstraints = false
        runnerStackView.widthAnchor.constraint(equalToConstant: CGFloat(80)).isActive = true
        
        diamondView.heightAnchor.constraint(equalToConstant: CGFloat(50)).isActive = true
        diamondView.widthAnchor.constraint(equalToConstant: CGFloat(50)).isActive = true

        
    }
    
    lazy var hitterLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.backgroundColor = awayColor(teamName: awayTeamName)
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textAlignment = .center
        if self.atBatEvent.count > 0 {
            if let number = atBatEvent[countStep].hitter?.jersey_number, let firstName = atBatEvent[countStep].hitter?.first_name, let lastName = atBatEvent[countStep].hitter?.last_name {
                label.text = "#\(number) \(firstName) \(lastName)"
            } else {
                guard let firstName = atBatEvent[countStep].hitter?.first_name else  {return label}
                guard let lastName = atBatEvent[countStep].hitter?.last_name else {return label}
                label.text = "\(firstName) \(lastName)"
            }
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
    
    var hitterStackView = UIStackView()
    
    func setUpHitter(scoreboardView: UIView, view: UIView) {
        
        hitterStackView = UIStackView(arrangedSubviews: [hittingPositionLabel, hitterLabel, tempo.timeLabel])
        view.addSubview(hitterStackView)
        hitterStackView.axis = .horizontal
        hitterStackView.spacing = 0
        hitterStackView.distribution = .fillProportionally
        
        hitterStackView.topAnchor.constraint(equalTo: scoreboardView.bottomAnchor, constant: 0).isActive = true
        hitterStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
        hitterStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0).isActive = true
        hitterStackView.translatesAutoresizingMaskIntoConstraints = false

        
        setupStadium(view: view, hitterLabel: hitterLabel)
        

    }
    
    
    
    var locationStackView = UIStackView()
    var insideStackView = UIStackView()
    var middleStackView = UIStackView()
    var outsideStackView = UIStackView()
    var strikeZoneStackViewHigh = UIStackView()
    var strikeZoneStackViewMiddle = UIStackView()
    var strikeZoneStackViewLow = UIStackView()
    
    func setupStadium(view: UIView, hitterLabel: UILabel){
        let stadiumView: UIImageView = {
            let imageView = UIImageView()
            imageView.image = UIImage(named: "rising2dtop stadium")
            imageView.contentMode = .scaleAspectFill
            imageView.clipsToBounds = true
            imageView.translatesAutoresizingMaskIntoConstraints = false
            return imageView
        }()
        
        let thirteen: UIButton = {
            let button = UIButton(type: .system)
            button.setTitle("13", for: .normal)
            button.setTitleColor(.black, for: .normal)
            button.backgroundColor = .white
            button.layer.borderWidth = 1
            button.layer.borderColor = UIColor.black.cgColor
            button.titleLabel?.font = .systemFont(ofSize: 20)
            button.addTarget(self, action: #selector(handleThirteen), for: .touchUpInside)
            
            return button
        }()
        
        let eleven: UIButton = {
            let button = UIButton(type: .system)
            button.setTitle("11", for: .normal)
            button.setTitleColor(.black, for: .normal)
            button.backgroundColor = .white
            button.layer.borderWidth = 1
            button.layer.borderColor = UIColor.black.cgColor
            button.titleLabel?.font = .systemFont(ofSize: 20)
            button.addTarget(self, action: #selector(handleEleven), for: .touchUpInside)
            
            return button
        }()
        
        let ten: UIButton = {
            let button = UIButton(type: .system)
            button.setTitle("10", for: .normal)
            button.setTitleColor(.black, for: .normal)
            button.backgroundColor = .white
            button.layer.borderWidth = 1
            button.layer.borderColor = UIColor.black.cgColor
            button.titleLabel?.font = .systemFont(ofSize: 20)
            button.addTarget(self, action: #selector(handleTen), for: .touchUpInside)
            
            return button
        }()
        
        let twelve: UIButton = {
            let button = UIButton(type: .system)
            button.setTitle("12", for: .normal)
            button.setTitleColor(.black, for: .normal)
            button.backgroundColor = .white
            button.layer.borderWidth = 1
            button.layer.borderColor = UIColor.black.cgColor
            button.titleLabel?.font = .systemFont(ofSize: 20)
            button.translatesAutoresizingMaskIntoConstraints = false
            button.addTarget(self, action: #selector(handleTwelve), for: .touchUpInside)
            
            return button
        }()
        
        let one: UIButton = {
            let button = UIButton(type: .system)
            button.setTitle("1", for: .normal)
            button.setTitleColor(.black, for: .normal)
            button.backgroundColor = .lightGray
            button.layer.borderWidth = 1
            button.layer.borderColor = UIColor.black.cgColor
            button.titleLabel?.font = .systemFont(ofSize: 20)
            button.addTarget(self, action: #selector(handleOne), for: .touchUpInside)
            
            return button
        }()
        
        let two: UIButton = {
            let button = UIButton(type: .system)
            button.setTitle("2", for: .normal)
            button.setTitleColor(.black, for: .normal)
            button.backgroundColor = .lightGray
            button.layer.borderWidth = 1
            button.layer.borderColor = UIColor.black.cgColor
            button.titleLabel?.font = .systemFont(ofSize: 20)
            button.addTarget(self, action: #selector(handleTwo), for: .touchUpInside)
            
            return button
        }()
        
        let three: UIButton = {
            let button = UIButton(type: .system)
            button.setTitle("3", for: .normal)
            button.setTitleColor(.black, for: .normal)
            button.backgroundColor = .lightGray
            button.layer.borderWidth = 1
            button.layer.borderColor = UIColor.black.cgColor
            button.titleLabel?.font = .systemFont(ofSize: 20)
            button.addTarget(self, action: #selector(handleThree), for: .touchUpInside)
            
            return button
        }()
        
        let four: UIButton = {
            let button = UIButton(type: .system)
            button.setTitle("4", for: .normal)
            button.setTitleColor(.black, for: .normal)
            button.backgroundColor = .lightGray
            button.layer.borderWidth = 1
            button.layer.borderColor = UIColor.black.cgColor
            button.titleLabel?.font = .systemFont(ofSize: 20)
            button.addTarget(self, action: #selector(handleFour), for: .touchUpInside)
            
            return button
        }()
        
        let five: UIButton = {
            let button = UIButton(type: .system)
            button.setTitle("5", for: .normal)
            button.setTitleColor(.black, for: .normal)
            button.backgroundColor = .lightGray
            button.layer.borderWidth = 1
            button.layer.borderColor = UIColor.black.cgColor
            button.titleLabel?.font = .systemFont(ofSize: 20)
            button.addTarget(self, action: #selector(handleFive), for: .touchUpInside)
            
            return button
        }()
        
        let six: UIButton = {
            let button = UIButton(type: .system)
            button.setTitle("6", for: .normal)
            button.setTitleColor(.black, for: .normal)
            button.backgroundColor = .lightGray
            button.layer.borderWidth = 1
            button.layer.borderColor = UIColor.black.cgColor
            button.titleLabel?.font = .systemFont(ofSize: 20)
            button.addTarget(self, action: #selector(handleSix), for: .touchUpInside)
            
            return button
        }()
        
        let seven: UIButton = {
            let button = UIButton(type: .system)
            button.setTitle("7", for: .normal)
            button.setTitleColor(.black, for: .normal)
            button.backgroundColor = .lightGray
            button.layer.borderWidth = 1
            button.layer.borderColor = UIColor.black.cgColor
            button.titleLabel?.font = .systemFont(ofSize: 20)
            button.addTarget(self, action: #selector(handleSeven), for: .touchUpInside)
            
            return button
        }()
        
        let eight: UIButton = {
            let button = UIButton(type: .system)
            button.setTitle("8", for: .normal)
            button.setTitleColor(.black, for: .normal)
            button.backgroundColor = .lightGray
            button.layer.borderWidth = 1
            button.layer.borderColor = UIColor.black.cgColor
            button.titleLabel?.font = .systemFont(ofSize: 20)
            button.addTarget(self, action: #selector(handleEigth), for: .touchUpInside)
            
            return button
        }()
        
        let nine: UIButton = {
            let button = UIButton(type: .system)
            button.setTitle("9", for: .normal)
            button.setTitleColor(.black, for: .normal)
            button.backgroundColor = .lightGray
            button.layer.borderWidth = 1
            button.layer.borderColor = UIColor.black.cgColor
            button.titleLabel?.font = .systemFont(ofSize: 20)
            button.addTarget(self, action: #selector(handleNine), for: .touchUpInside)
            
            return button
        }()
        
        view.addSubview(stadiumView)
        stadiumView.topAnchor.constraint(equalTo: hitterLabel.bottomAnchor, constant: 0).isActive = true
        stadiumView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 0).isActive = true
        stadiumView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 0).isActive = true
        stadiumView.heightAnchor.constraint(equalToConstant: self.view.frame.height / 2 + 100).isActive = true
        stadiumView.isUserInteractionEnabled = true
        
        locationStackView = UIStackView(arrangedSubviews: [insideStackView, middleStackView, outsideStackView])
        locationStackView.translatesAutoresizingMaskIntoConstraints = false
        stadiumView.addSubview(locationStackView)
        stadiumView.addSubview(twelve)
        
        locationStackView.axis = .horizontal
        locationStackView.distribution = .fillProportionally

        locationStackView.centerXAnchor.constraint(equalTo: stadiumView.centerXAnchor, constant: -(view.frame.width / 2) / 2 + 105).isActive = true
        locationStackView.centerYAnchor.constraint(equalTo: stadiumView.centerYAnchor, constant: (view.frame.height / 2) / 2 - 150).isActive = true

        locationStackView.widthAnchor.constraint(equalToConstant: CGFloat(170)).isActive = true

        locationStackView.heightAnchor.constraint(equalToConstant: CGFloat(200)).isActive = true

        insideStackView = UIStackView(arrangedSubviews: [thirteen])
        insideStackView.translatesAutoresizingMaskIntoConstraints = false
        locationStackView.addSubview(insideStackView)
        insideStackView.axis = .vertical
        insideStackView.distribution = .fillEqually


        insideStackView.topAnchor.constraint(equalTo: locationStackView.topAnchor, constant: 0).isActive = true
        insideStackView.leadingAnchor.constraint(equalTo: locationStackView.leadingAnchor, constant: 0).isActive = true
        insideStackView.bottomAnchor.constraint(equalTo: locationStackView.bottomAnchor, constant: 0).isActive = true
        insideStackView.widthAnchor.constraint(equalToConstant: CGFloat(30)).isActive = true

        middleStackView = UIStackView(arrangedSubviews: [ten, strikeZoneStackViewHigh, strikeZoneStackViewMiddle, strikeZoneStackViewLow, twelve])
        middleStackView.translatesAutoresizingMaskIntoConstraints = false
        locationStackView.addSubview(middleStackView)
        middleStackView.axis = .vertical
        middleStackView.distribution = .fillEqually

        middleStackView.topAnchor.constraint(equalTo: locationStackView.topAnchor, constant: 0).isActive = true
        middleStackView.leadingAnchor.constraint(equalTo: insideStackView.trailingAnchor, constant: 0).isActive = true
        middleStackView.bottomAnchor.constraint(equalTo: locationStackView.bottomAnchor, constant: 0).isActive = true
        middleStackView.widthAnchor.constraint(equalToConstant: CGFloat(100)).isActive = true

        
        outsideStackView = UIStackView(arrangedSubviews: [eleven])
        outsideStackView.translatesAutoresizingMaskIntoConstraints = false
        locationStackView.addSubview(outsideStackView)
        outsideStackView.axis = .vertical
        outsideStackView.distribution = .fillEqually
        
        outsideStackView.topAnchor.constraint(equalTo: locationStackView.topAnchor, constant: 0).isActive = true
        outsideStackView.leadingAnchor.constraint(equalTo: middleStackView.trailingAnchor, constant: 0).isActive = true
        outsideStackView.bottomAnchor.constraint(equalTo: locationStackView.bottomAnchor, constant: 0).isActive = true
        outsideStackView.widthAnchor.constraint(equalToConstant: CGFloat(30)).isActive = true
        outsideStackView.trailingAnchor.constraint(equalTo: locationStackView.trailingAnchor, constant: 0).isActive = true

        strikeZoneStackViewHigh = UIStackView(arrangedSubviews: [one, two, three])
        strikeZoneStackViewHigh.translatesAutoresizingMaskIntoConstraints = false
        locationStackView.addSubview(strikeZoneStackViewHigh)
        strikeZoneStackViewHigh.axis = .horizontal
        strikeZoneStackViewHigh.distribution = .fillEqually

        strikeZoneStackViewHigh.topAnchor.constraint(equalTo: ten.bottomAnchor, constant: 0).isActive = true
        strikeZoneStackViewHigh.leadingAnchor.constraint(equalTo: insideStackView.trailingAnchor, constant: 0).isActive = true
        strikeZoneStackViewHigh.trailingAnchor.constraint(equalTo: outsideStackView.leadingAnchor, constant: 0).isActive = true
        strikeZoneStackViewHigh.heightAnchor.constraint(equalToConstant: CGFloat(40)).isActive = true

        strikeZoneStackViewMiddle = UIStackView(arrangedSubviews: [four, five, six])
        strikeZoneStackViewMiddle.translatesAutoresizingMaskIntoConstraints = false
        locationStackView.addSubview(strikeZoneStackViewMiddle)
        strikeZoneStackViewMiddle.axis = .horizontal
        strikeZoneStackViewMiddle.distribution = .fillEqually

        strikeZoneStackViewMiddle.topAnchor.constraint(equalTo: strikeZoneStackViewHigh.bottomAnchor, constant: 0).isActive = true
        strikeZoneStackViewMiddle.leadingAnchor.constraint(equalTo: insideStackView.trailingAnchor, constant: 0).isActive = true
        strikeZoneStackViewMiddle.trailingAnchor.constraint(equalTo: outsideStackView.leadingAnchor, constant: 0).isActive = true
        strikeZoneStackViewMiddle.heightAnchor.constraint(equalToConstant: CGFloat(40)).isActive = true

        strikeZoneStackViewLow = UIStackView(arrangedSubviews: [seven, eight, nine])
        strikeZoneStackViewLow.translatesAutoresizingMaskIntoConstraints = false
        locationStackView.addSubview(strikeZoneStackViewLow)
        strikeZoneStackViewLow.axis = .horizontal
        strikeZoneStackViewLow.distribution = .fillEqually

        strikeZoneStackViewLow.topAnchor.constraint(equalTo: strikeZoneStackViewMiddle.bottomAnchor, constant: 0).isActive = true
        strikeZoneStackViewLow.leadingAnchor.constraint(equalTo: insideStackView.trailingAnchor, constant: 0).isActive = true
        strikeZoneStackViewLow.trailingAnchor.constraint(equalTo: outsideStackView.leadingAnchor, constant: 0).isActive = true
        strikeZoneStackViewLow.heightAnchor.constraint(equalToConstant: CGFloat(40)).isActive = true
        
       


        twelve.topAnchor.constraint(equalTo: strikeZoneStackViewLow.bottomAnchor, constant: 0).isActive = true
        twelve.leadingAnchor.constraint(equalTo: insideStackView.trailingAnchor, constant: 0).isActive = true

        twelve.bottomAnchor.constraint(equalTo: locationStackView.bottomAnchor, constant: 0).isActive = true

        twelve.heightAnchor.constraint(equalToConstant: CGFloat(30)).isActive = true
        ten.heightAnchor.constraint(equalToConstant: CGFloat(30)).isActive = true

        
        setupPitchesButtons(view: view, stadium: stadiumView)
    }
    
    
    var pitchesStackView = UIStackView()
    
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
            button.titleLabel?.font = .systemFont(ofSize: 20)
            button.addTarget(self, action: #selector(handleCurveBall), for: .touchUpInside)
            
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
            button.titleLabel?.font = .systemFont(ofSize: 20)
            button.addTarget(self, action: #selector(handleKnuckleball), for: .touchUpInside)
            
            return button
        }()
        
        pitchesStackView = UIStackView(arrangedSubviews: [fastball, curveBall, slider, cutter, changeUp, knuckleBall])
        pitchesStackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(pitchesStackView)
        pitchesStackView.axis = .vertical
        pitchesStackView.spacing = 0
        pitchesStackView.distribution = .fillEqually
        
        pitchesStackView.topAnchor.constraint(equalTo: stadium.bottomAnchor, constant: 0).isActive = true
        pitchesStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
        pitchesStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0).isActive = true
        pitchesStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0).isActive = true
        

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
    
    @objc func handleOne(sender: UIButton) {
        print("One")
    }
    
    @objc func handleTwo(sender: UIButton) {
        print("Two")
    }
    
    @objc func handleThree(sender: UIButton) {
        print("Three")
    }
    
    @objc func handleFour(sender: UIButton) {
        print("Four")
    }
    
    @objc func handleFive(sender: UIButton) {
        print("Five")
    }
    
    @objc func handleSix(sender: UIButton) {
        print("Six")
    }
    
    @objc func handleSeven(sender: UIButton) {
        print("Seven")
    }
    
    @objc func handleEigth(sender: UIButton) {
        print("Eigth")
    }
    
    @objc func handleNine(sender: UIButton) {
        print("Nine")
    }
    
    @objc func handleTen(sender: UIButton) {
        print("Ten")
    }
    
    @objc func handleEleven(sender: UIButton) {
        print("Eleven")
    }
    
    @objc func handleTwelve(sender: UIButton) {
        print("Twelve")
    }
    
    @objc func handleThirteen(sender: UIButton) {
        print("Thirteen")
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
//        for event in inning.halfs[0].events {
//            self.topEvents.append(event)
//        }
        self.topEvents = inning.halfs[0].events
        
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
        self.type = atBatEvent.compactMap {$0.type}
        
        
        
        for event in atBatEvent {
            guard let count = event.count else {return}
            guard let flags = event.flags else {return}
            guard let type = event.type else {return}
            
            
            
            print("""
                
                Count \(self.counts.count): \(count)
                flags \(self.flags.count): \(flags)
                type \(self.type.count): \(type)
                
                
                
                
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
        countStep += 1
//        stepsVariation(atBatEvents: atBatEvent, step: countStep)
        countStepper(count: counts, flags: flags, step: countStep)
       
    }
    
    // change hitters label
    func hitting(hitterCounter: Int) {
        if hitterCounter < topEvents.count {
            guard let number = topEvents[hitterCounter].at_bat?.hitter.jersey_number else {return}
            guard let firstName = topEvents[hitterCounter].at_bat?.hitter.first_name else {return}
            guard let lastName = topEvents[hitterCounter].at_bat?.hitter.last_name else {return }
            
            self.hitterLabel.text = "#\(number) \(firstName) \(lastName)"
        } else {
            self.hitterCounter = topEvents.count - 1
            guard let number = topEvents[self.hitterCounter].at_bat?.hitter.jersey_number else {return}
            guard let firstName = topEvents[self.hitterCounter].at_bat?.hitter.first_name else {return}
            guard let lastName = topEvents[self.hitterCounter].at_bat?.hitter.last_name else {return }
            
            self.hitterLabel.text = "#\(number) \(firstName) \(lastName)"
        }
        
    }
    
    
    
    func countStepper(count: [Count], flags: [Flags], step: Int) {
        if atBatEvent.count <= countStep {
            countStep -= atBatEvent.count - 1
        }
        print("""
            
            CountStep: \(countStep - 1)
            => \(atBatEvent[countStep - 1])
            hitter counter: \(hitterCounter)
            
            """)
        hitting(hitterCounter: hitterCounter)
        
        if count.count <= 0 {
            dismissView()
            return
        }
//        if count[stept - 1] >= countStep - 1 {
//            
//        }
        print("""
            
            Count \(count.count): \(count)
            
            
            
            
            Balls \(step - 1): \(count[step - 1].balls)
            Strikes \(step - 1): \(count[step - 1].strikes)
            OUTs \(step - 1): \(count[step - 1].outs)
            Pitch Count \(step - 1): \(count[step - 1].pitch_count)
            
            
            """)
        var flagSteps = step - 1
        
        if count[step - 1].outs == 0 {
            outsView.image = outs(manyOuts: count[step - 1].outs)
            if type[step - 1] == "pitch" {
                if flags.count <= flagSteps {
                    flagSteps -= flags.count - 1
                }
                if flags[flagSteps].is_ab_over || flags[flagSteps].is_hit {
                    countLabel.text = "\(0)-\(0)"
                    hitterCounter += 1
//                    hitting(hitterCounter: hitterCounter)
                } else {
                    countLabel.text = "\(count[step - 1].balls)-\(count[step - 1].strikes)"
                }
            } else {
                countLabel.text = "\(count[step - 1].balls)-\(count[step - 1].strikes)"
                flagSteps -= 1
            }
            
        } else if count[step - 1].outs == 1 {
            outsView.image = outs(manyOuts: count[step - 1].outs)
            if type[step - 1] == "pitch" {
                if flags.count <= flagSteps {
                    flagSteps -= flags.count - 1
                }
                if flags[flagSteps].is_ab_over || flags[flagSteps].is_hit {
                     countLabel.text = "\(0)-\(0)"
                    hitterCounter += 1
//                    hitting(hitterCounter: hitterCounter)
                } else {
                    countLabel.text = "\(count[step - 1].balls)-\(count[step - 1].strikes)"
                }
            } else {
                countLabel.text = "\(count[step - 1].balls)-\(count[step - 1].strikes)"
                flagSteps -= 1
            }
            
        } else if count[step - 1].outs == 2 {
            outsView.image = outs(manyOuts: count[step - 1].outs)
            if type[step - 1] == "pitch" {
                if flags.count <= flagSteps {
                    flagSteps -= flags.count - 1
                }
                if flags[flagSteps].is_ab_over || flags[flagSteps].is_hit {
                    countLabel.text = "\(0)-\(0)"
                    hitterCounter += 1
//                    hitting(hitterCounter: hitterCounter)
                } else {
                    countLabel.text = "\(count[step - 1].balls)-\(count[step - 1].strikes)"
                }
            } else {
                countLabel.text = "\(count[step - 1].balls)-\(count[step - 1].strikes)"
                flagSteps -= 1
            }
        } else if count[step - 1].outs == 3 {
            outsView.image = outs(manyOuts: count[step - 1].outs)
            if type[step - 1] == "pitch" {
                if flags.count <= flagSteps {
                    flagSteps -= flags.count - 1
                }
                if flags[flagSteps].is_ab_over || flags[flagSteps].is_hit {
                    countLabel.text = "\(0)-\(0)"
//                    hitterCounter += 1
//                    hitting(hitterCounter: hitterCounter)
                } else {
                    countLabel.text = "\(count[step - 1].balls)-\(count[step - 1].strikes)"
                }
            } else {
                countLabel.text = "\(count[step - 1].balls)-\(count[step - 1].strikes)"
                flagSteps -= 1
            }
            self.counts = []
            self.flags = []
            self.type = []
            print("""
                
                Second Inning:
                
                Count \(count.count): \(count)
                
                
                
                Balls \(step - 1): \(count[step - 1].balls)
                Strikes \(step - 1): \(count[step - 1].strikes)
                OUTs \(step - 1): \(count[step - 1].outs)
                Pitch Count \(step - 1): \(count[step - 1].pitch_count)
                
                
                """)
            inningCount += 1
            hitterCounter = 0
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
