//
//  ViewController.swift
//  MLB Game Situation
//
//  Created by Ramon Geronimo on 3/15/19.
//  Copyright © 2019 Ramon Geronimo. All rights reserved.
//

import UIKit

class HomeController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    var games: [[String : Game]] = []
    let client = MLBApiServiceGames(year: 2019, month: 03, day: 10)
    

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

    }
    
    @objc func reloadCollectionview(){
        print("Reloading.....")
        self.games = client.returnSources()
        self.collectionView.reloadData()
    }
    
    func setupNavBarButtons(){
        let searchImage = UIImage(named: "search_icon")?.withRenderingMode(.alwaysOriginal)
        let moreImage = UIImage(named: "nav_more_icon")?.withRenderingMode(.alwaysOriginal)
        let searchBarButtonItem = UIBarButtonItem(image: searchImage, style: .plain, target: self, action: #selector(handleSearch))
        let moreButton = UIBarButtonItem(image: moreImage, style: .plain, target: self, action: #selector(handleMore))
        navigationItem.rightBarButtonItems = [searchBarButtonItem, moreButton]
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
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellID", for: indexPath) as! BaseballCardCell

        cell.titleLabel.text = "\((games[indexPath.row]["game"]?.home.name)!) vs \((games[indexPath.row]["game"]?.away.name)!)"
        cell.subtitleTextView.text = "Status: \(String(describing: (games[indexPath.row]["game"]?.status)!)) – Double Header: \(String(describing: (games[indexPath.row]["game"]?.double_header)!))"
        cell.baseballCardView.image = UIImage(named: stadium(name: (games[indexPath.row]["game"]?.home.name)!))
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 500)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        
    }
    
    func stadium(name: String) -> String {
        if name == "Angels"{
            return "ANGELS"
        } else if name == "Cubs"{
            return "WRINGLEY"
        } else if name == "Rangers" {
            return "ARLINGTON1"
        } else if name == "Cardinals" {
            return "BUSCH"
        } else if name == "Orioles" {
            return "CAMDEN"
        } else if name == "Mets" {
            return "CITI"
        } else if name == "Athletics" {
            return "COLISEUM"
        } else if name == "Tigers" {
            return "COMERICA PARK"
        } else if name == "Red Sox" {
            return "FENWAY"
        } else if name == "Reds" {
            return "GREAT AMERICA"
        } else if name == "Royals" {
            return "KAUFFMAN"
        } else if name == "Astros" {
            return "MINUTE MAID"
        } else if name == "Nationals" {
            return "NATIONALS"
        } else if name == "Pirates" {
            return "PNC"
        } else if name == "Blue Jays" {
            return "ROGERS"
        } else if name == "Mariners" {
            return "SAFECO MOD"
        } else if name == "Twins" {
            return "TARGET"
        } else if name == "Rays" {
            return "TROPICANA"
        } else if name == "White Sox" {
            return "US CELLULAR2"
        } else {
            return "Rising To The Top - Logo"
        }
    }
    
}

