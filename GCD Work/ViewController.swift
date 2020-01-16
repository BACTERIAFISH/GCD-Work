//
//  ViewController.swift
//  GCD Work
//
//  Created by FISH on 2020/1/14.
//  Copyright © 2020 FISH. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var groupRoadLabel0: UILabel!
    @IBOutlet weak var groupLimitLabel0: UILabel!
    @IBOutlet weak var groupRoadLabel10: UILabel!
    @IBOutlet weak var groupLimitLabel10: UILabel!
    @IBOutlet weak var groupRoadLabel20: UILabel!
    @IBOutlet weak var groupLimitLabel20: UILabel!
    
    @IBOutlet weak var semaphoreRoadLabel0: UILabel!
    @IBOutlet weak var semaphoreLimitLabel0: UILabel!
    @IBOutlet weak var semaphoreRoadLabel10: UILabel!
    @IBOutlet weak var semaphoreLimitLabel10: UILabel!
    @IBOutlet weak var semaphoreRoadLabel20: UILabel!
    @IBOutlet weak var semaphoreLimitLabel20: UILabel!
    
    let manager = Manager()
    
    var groupRoad0 = ""
    var groupLimit0 = ""
    var groupRoad10 = ""
    var groupLimit10 = ""
    var groupRoad20 = ""
    var groupLimit20 = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        URLSession.shared.delegateQueue.maxConcurrentOperationCount = 3
    }
    
    @IBAction func startGroup(_ sender: UIButton) {
        
        cleanGroup()
        
        let group = DispatchGroup()
        
        group.enter()
        manager.fetch(offset: 0) { [weak self] result in
            switch result {
            case .success(let data):
                self?.groupRoad0 = data.results[0].road
                self?.groupLimit0 = data.results[0].speedLimit
            case .failure(let error):
                print(error)
            }
            group.leave()
        }
        
        group.enter()
        manager.fetch(offset: 10) { [weak self] result in
            switch result {
            case .success(let data):
                self?.groupRoad10 = data.results[0].road
                self?.groupLimit10 = data.results[0].speedLimit
            case .failure(let error):
                print(error)
            }
            group.leave()
        }
        
        group.enter()
        manager.fetch(offset: 20) { [weak self] result in
            switch result {
            case .success(let data):
                self?.groupRoad20 = data.results[0].road
                self?.groupLimit20 = data.results[0].speedLimit
            case .failure(let error):
                print(error)
            }
            group.leave()
        }
        
        group.notify(queue: .main) { [weak self] in
            self?.groupRoadLabel0.text = self?.groupRoad0
            self?.groupLimitLabel0.text = self?.groupLimit0
            self?.groupRoadLabel10.text = self?.groupRoad10
            self?.groupLimitLabel10.text = self?.groupLimit10
            self?.groupRoadLabel20.text = self?.groupRoad20
            self?.groupLimitLabel20.text = self?.groupLimit20
        }
    }
    
    let semaphore1 = DispatchSemaphore(value: 0)
    let semaphore2 = DispatchSemaphore(value: 0)
    
    @IBAction func startSemaphore(_ sender: UIButton) {
        
        cleanSemaphore()
        
        manager.fetch(offset: 0) { [weak self] result in
            switch result {
            case .success(let data):
                DispatchQueue.main.async {
                    self?.semaphoreRoadLabel0.text = data.results[0].road
                    self?.semaphoreLimitLabel0.text = data.results[0].speedLimit
                    self?.semaphore1.signal()
                }
            case .failure(let error):
                print(error)
                self?.semaphore1.signal()
            }
            
        }
        
        manager.fetch(offset: 10) { [weak self] result in
            self?.semaphore1.wait()
            switch result {
            case .success(let data):
                DispatchQueue.main.async {
                    self?.semaphoreRoadLabel10.text = data.results[0].road
                    self?.semaphoreLimitLabel10.text = data.results[0].speedLimit
                    self?.semaphore2.signal()
                }
            case .failure(let error):
                print(error)
                self?.semaphore2.signal()
            }
        }
        
        manager.fetch(offset: 20) { [weak self] result in
            self?.semaphore2.wait()
            switch result {
            case .success(let data):
                DispatchQueue.main.async {
                    self?.semaphoreRoadLabel20.text = data.results[0].road
                    self?.semaphoreLimitLabel20.text = data.results[0].speedLimit
                }
            case .failure(let error):
                print(error)
            }
        }
        
    }
    
    func cleanGroup() {
        groupRoadLabel0.text = ""
        groupRoadLabel10.text = ""
        groupRoadLabel20.text = ""
        groupLimitLabel0.text = ""
        groupLimitLabel10.text = ""
        groupLimitLabel20.text = ""
    }
    
    func cleanSemaphore() {
        semaphoreRoadLabel0.text = ""
        semaphoreRoadLabel10.text = ""
        semaphoreRoadLabel20.text = ""
        semaphoreLimitLabel0.text = ""
        semaphoreLimitLabel10.text = ""
        semaphoreLimitLabel20.text = ""
    }
}
