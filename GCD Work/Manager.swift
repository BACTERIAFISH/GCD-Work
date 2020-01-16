//
//  Manager.swift
//  GCD Work
//
//  Created by FISH on 2020/1/14.
//  Copyright © 2020 FISH. All rights reserved.
//

import Foundation

class Manager {
    
    let url = "https://data.taipei/opendata/datalist/apiAccess?scope=resourceAquire&rid=5012e8ba-5ace-4821-8482-ee07c147fd0a&limit=1&offset="
    
    func fetch(offset: Int, completion: @escaping (Result<SCSpeed, Error>) -> Void) {
        let api = "\(url)\(offset)"
        
        guard let url = URL(string: api) else { return }
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                completion(Result.failure(error))
                return
            }
            
            guard let response = response as? HTTPURLResponse, let data = data else {
                return
            }
            
            switch response.statusCode {
            case 200..<300:
                let decoder = JSONDecoder()
                do {
                    let result = try decoder.decode(SCResponse.self, from: data)
                    //print(result.result)
                    completion(Result.success(result.result))
                } catch {
                    completion(Result.failure(error))
                }
                
            default:
                print("unexpected error")
                //                DispatchQueue.main.async {
                //                    completion(Result.failure(error))
                //                }
            }
            
        }
        
        task.resume()
    }
    
}

struct SCResponse: Codable {
    let result: SCSpeed
}

struct SCSpeed: Codable {
    let limit: Int
    let offset: Int
    let count: Int
    let sort: String
    let results: [SCSpeedResult]
}

struct SCSpeedResult: Codable {
    let functions: String
    let area: String
    let no: String
    let direction: String
    let speedLimit: String
    let location: String
    let id: Int
    let road: String
    
    private enum CodingKeys: String, CodingKey {
        case functions, area, no, direction, location, road
        case speedLimit = "speed_limit"
        case id = "_id"
    }
}
