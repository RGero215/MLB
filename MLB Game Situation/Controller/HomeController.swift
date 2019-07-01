//
//  ViewController.swift
//  MLB Game Situation
//
//  Created by Ramon Geronimo on 3/15/19.
//  Copyright © 2019 Ramon Geronimo. All rights reserved.
//

import UIKit

protocol HomeControllerDelegate: class {
    func loadPlays()
}

class HomeController: UICollectionViewController, UICollectionViewDelegateFlowLayout, HomeControllerDelegate {
    
    var games: [[String : Game]] = []
    var game: MLBApiServiceGame?
    var pitchByPitch: PitchByPitch?
    let client = MLBApiServiceGames(year: 2019, month: 03, day: 10)
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Home"
        navigationController?.navigationBar.isTranslucent = false
        
        let titleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: view.frame.width - 32, height: view.frame.height))
        titleLabel.text = "Home"
        titleLabel.textColor = UIColor.white
        titleLabel.font = UIFont.systemFont(ofSize: 20)
        navigationItem.titleView = titleLabel
        
        collectionView.backgroundColor = UIColor.white
        collectionView.register(BaseballCardCell.self, forCellWithReuseIdentifier: "cellID")
        
        collectionView.contentInset = UIEdgeInsets(top: 50, left: 0, bottom: 0, right: 0)
        collectionView.scrollIndicatorInsets = UIEdgeInsets(top: 50, left: 0, bottom: 0, right: 0)
        
        setupMenuBar()
        
        setupNavBarButtons()
        
        client.fetchSources()
        
        NotificationCenter.default.addObserver(self, selector: #selector(reloadCollectionview), name: NSNotification.Name(rawValue: "reloadCollectionView"), object: nil)
        
        cardLauncher.delegate = self
        

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        appDelegate.statusBarBackgroundView.backgroundColor = UIColor.rgb(red: 194, green: 31, blue: 31)

        
    }
    
    @objc func reloadCollectionview(){
        print("Reloading.....")
        self.games = client.returnSources()
        self.collectionView.reloadData()
    }
    
    @objc func loadPlayByPlay(){
        print("loading.....")
       
        let queue = DispatchQueue(label: "Pitch by Pitch")
        queue.sync {
            self.pitchByPitch = self.game?.returnSources()
            self.activityIndicatorView.stopAnimating()
        }
    
        loadPlays()
        
        if !cardLauncher.isBeingPresented {
            // Present your ViewController only if its not present to the user currently.
            self.present(self.cardLauncher, animated: true)
        }

    }
    
    
    func setupNavBarButtons(){
        let searchImage = UIImage(named: "search_icon")?.withRenderingMode(.alwaysOriginal)
        let moreImage = UIImage(named: "nav_more_icon")?.withRenderingMode(.alwaysOriginal)
        let searchBarButtonItem = UIBarButtonItem(image: searchImage, style: .plain, target: self, action: #selector(handleSearch))
        let moreButton = UIBarButtonItem(image: moreImage, style: .plain, target: self, action: #selector(handleMore))
        navigationItem.rightBarButtonItems = [moreButton, searchBarButtonItem]
    }
    
    @objc func handleSearch(){
        
    }
    
    @objc func handleMore(){
        
    }
    
    let menuBar: MenuBar = {
        let mb = MenuBar()
        return mb
    }()
    
    private func setupMenuBar() {
        view.addSubview(menuBar)
        view.addConstraintsWithFormat(format: "H:|[v0]|", views: menuBar)
        view.addConstraintsWithFormat(format: "V:|[v0(50)]", views: menuBar)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        navigationController?.navigationBar.barStyle = .black
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return games.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell = BaseballCardCell()
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellID", for: indexPath) as! BaseballCardCell
        guard let home = games[indexPath.row]["game"]?.home.name else {return cell}
        guard let away = games[indexPath.row]["game"]?.away.name else {return cell}
        guard let status = games[indexPath.row]["game"]?.status else {return cell}
        guard let doubleHeader = games[indexPath.row]["game"]?.double_header else {return cell}
        cell.titleLabel.text = "\(home) vs \(away)"
        cell.subtitleTextView.text = "Status: \(status) – Double Header: \(doubleHeader)"
        cell.baseballCardView.image = UIImage(named: stadium(name: home))
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 500)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    let cardLauncher = CardLauncher()
    
    let activityIndicatorView: UIActivityIndicatorView = {
        let aiv = UIActivityIndicatorView(style: .gray)
        aiv.translatesAutoresizingMaskIntoConstraints = false
        aiv.startAnimating()
        return aiv
    }()
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        
        
        view.addSubview(activityIndicatorView)
        
        activityIndicatorView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        activityIndicatorView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        activityIndicatorView.startAnimating()
        
        guard let id = games[indexPath.row]["game"]?.id else {return}
        game = MLBApiServiceGame(id: id)

        
        self.game?.fetchSources()
    
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(loadPlayByPlay), name: NSNotification.Name(rawValue: "playByPlay"), object: nil)
        
    }
    
    @objc func loadPlays() {
        print("""


                
                    Working Fine!



            
            """)
        cardLauncher.pitchByPitch = self.pitchByPitch
        
    }
    
    
    
}

