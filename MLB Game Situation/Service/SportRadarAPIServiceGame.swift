//
//  SportRadarAPIServiceGame.swift
//  MLB Game Situation
//
//  Created by Ramon Geronimo on 3/20/19.
//  Copyright © 2019 Ramon Geronimo. All rights reserved.
//

import UIKit

class MLBApiServiceGame {
    
    var sources: PitchByPitch?
    
    private let urlScheme = "http"
    private let baseURLString = "api.sportradar.us"
    private var sourcesEndpoint = ""
    var id: String
    
    
    init(id: String) {
        self.id = id
        self.sourcesEndpoint = "/mlb/trial/v6.5/en/games/\(id)/pbp.json?api_key=rvp6m6tpmmpaauqmm7v3pcfe"
    }
    
    
    
    
    // Function that fetches all Source items from newsapi.org...
    func fetchSources() {
        
        //Set up URLSession, URL, and URLRequest
        let session = URLSession(configuration: .default)
        guard let url = URL(string: self.urlBuilder()!) else { return }
        let urlRequest = URLRequest(url: url)
        
        //Execute dataTask and call method to process sources
        let task = session.dataTask(with: urlRequest, completionHandler: { (data, response, error) -> Void in
            
            //            print(data?.prettyPrintedJSONString)
            if let data = data {
                DispatchQueue.main.async {
                    
                    self.processSourcesFetchRequest(data: data, error: error)
                    
                    
                }
            }
        })
        task.resume()
        
    }
    
    // Function for validating response data exists or presenting HTTP error
    private func processSourcesFetchRequest(data: Data?, error: Error?) {
        
        // if data passed is nil, print error
        guard let jsonData = data else {
            print(error!)
            return
        }
        self.decodeSourceItems(fromJSON: jsonData)
    }
    
    // Function for decoding fetches all Source items from newsapi.org...
    func decodeSourceItems(fromJSON data: Data) {
        
        do {
            let decoder = JSONDecoder()
            let decodedResponseObject = try decoder.decode(PitchByPitch.self, from: data)
            
            DispatchQueue.main.async {
                self.sources = decodedResponseObject
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "playByPlay"), object: nil)
                print(decodedResponseObject)
                
            }
        } catch let jsonError {
            print("Error: \(jsonError)")
            
        }
    }
    
    private func urlBuilder() -> String? {
        
        var components = URLComponents()
        components.scheme = urlScheme
        components.host = baseURLString
        components.path = sourcesEndpoint
        
        if let urlAsString = components.url?.absoluteString {
            let percentDecodedURL = urlAsString.decodeUrl()
            return percentDecodedURL
        } else {
            return "Invalid URL"
        }
    }
    
    func returnSources() -> PitchByPitch {
        return self.sources!
    }
}
