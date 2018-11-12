//
//  forces.swift
//  CodeForces
//
//  Created by Rithwik Srikakolapu on 23/10/18.
//  Copyright © 2018 Rithwik Srikakolapu. All rights reserved.
//

import Foundation

struct forces{
    let handle:String
    let rank:String
    let rating:Int
    let maxRank:String
    let contribution:Int
    let maxRating:Int
    
    enum SerialiarionError : Error{
        case missing(String)
        case Invalid(String,Any)
    }
    
    init(json:[String:Any]) throws{
        guard let handle = json["handle"] as? String else{throw SerialiarionError.missing("missing handle")}
        guard let rank = json["rank"] as? String else{throw SerialiarionError.missing("missing rank")}
        guard let rating = json["rating"] as? Int else{throw SerialiarionError.missing("missing rating")}
        guard let maxRating = json["maxRating"] as? Int else{throw SerialiarionError.missing("missing maxRating")}
        guard let maxRank = json["maxRank"] as? String else{throw SerialiarionError.missing("missing maxRank")}
        guard let contribution = json["contribution"] as? Int else{throw SerialiarionError.missing("missing contribution")}
        
        self.handle = handle
        self.rank = rank
        self.rating = rating
        self.maxRating = maxRating
        self.maxRank = maxRank
        self.contribution = contribution
        
            }
    static let basePath="https2://codeforces.com/api/user.info?handles="
    static func info(method:String, completion:@escaping ([forces])-> ()){
        let url = basePath + method
        let request = URLRequest(url: URL(string: url)!)
        
        let task = URLSession.shared.dataTask(with: request) { (data:Data?, response:URLResponse?, error:Error?) in
            var infoArray:[forces] = []
            if let data = data{
                do{
                    if let json = try JSONSerialization.jsonObject(with: data, options: [])as? [String:Any]{
                        if let infoResults = json["result"] as? [[String:Any]]{
                            for d in infoResults {
                                if let infoObj = try?  forces(json: d){
                                    infoArray.append(infoObj)
                                }
                            }
                        }
                    }
                }catch{
                    print(error.localizedDescription)
                }
                completion(infoArray)
            }
        }
        task.resume()
        
    }
}
