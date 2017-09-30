//
//  ViewController.swift
//  Movie Finder
//
//  Created by AKIL KUMAR THOTA on 9/29/17.
//  Copyright © 2017 Akil Kumar Thota. All rights reserved.
//

import UIKit

class MainVC: UIViewController {
    

    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var segmentControle: UISegmentedControl!
    
    
    
    var movieArray = [Movie]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
        tableview.delegate = self
        tableview.dataSource = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    func loadData(){
        let urlString = "https://data.sfgov.org/api/views/yitu-d5am/rows.json?accessType=DOWNLOAD"
        guard let url = URL(string: urlString) else {return }
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error  = error {
                print(error.localizedDescription)
            }else{
                guard let data = data else {return}
                guard let jsonResult = try? JSONSerialization.jsonObject(with: data, options:.allowFragments) as? [String:Any] else {return }
                
                guard let jsonObject = jsonResult else {return}
                
                if let data = jsonObject["data"] as? [Array<Any>] {
                    for x in data {
                        var mainTitle = "Not Available"
                        var mainYear = 0000
                        var mainLocation = "Not Available"
                        if let title = x[8] as? String {
                            mainTitle = title
                        }
                        if let year = x[9] as? String {
                            if let convertedYear = Int(year) {
                                mainYear = convertedYear
                            }
                        }
                        
                        if let location = x[10] as? String {
                            mainLocation = location
                        }
                        
                        let movie = Movie(title: mainTitle, year: mainYear, location: mainLocation)
                        
                        self.movieArray.append(movie)
                    }
                }
                DispatchQueue.main.async {
                    self.tableview.reloadData()
                }
                guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
                let managedCOntext = appDelegate.persistentContainer.viewContext
            }
            
        }.resume()
    }

}


extension MainVC: UITableViewDelegate,UITableViewDataSource {
    
    //MARK: Table View DatSource Methods
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? MovieCell {
            let movie = movieArray[indexPath.row]
            cell.configureCell(movie: movie)
            return cell
        } else {
            return UITableViewCell()
        }
        
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movieArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 160
    }
    
    
    
   
    //MARK: Table View Delegate Methods
    
//    func tableView(_ tableView: UITableView, shouldSpringLoadRowAt indexPath: IndexPath, with context: UISpringLoadedInteractionContext) -> Bool {
//        return true
//    }
    
    
    
    
}

