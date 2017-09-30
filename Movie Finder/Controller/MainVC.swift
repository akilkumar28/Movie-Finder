//
//  ViewController.swift
//  Movie Finder
//
//  Created by AKIL KUMAR THOTA on 9/29/17.
//  Copyright © 2017 Akil Kumar Thota. All rights reserved.
//

import UIKit
import CoreData

class MainVC: UIViewController {
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var segmentControle: UISegmentedControl!
    
    
    var check = false
    var movieArray = [NSManagedObject]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        check = true
        checkData()
        tableview.delegate = self
        tableview.dataSource = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if !check{
            checkData()
        }
    }
    
    func checkData(){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let managedContxt = appDelegate.persistentContainer.viewContext
        
        let fetchrequest = NSFetchRequest<NSManagedObject>(entityName: "Movies")
        
        do {
            self.movieArray = try managedContxt.fetch(fetchrequest)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        
        if self.movieArray.count < 1 {
            loadData()
        }
        self.activityIndicator.isHidden = true
        self.check = false
    }
    
    func loadData(){
    
        let urlString = "https://data.sfgov.org/api/views/yitu-d5am/rows.json?accessType=DOWNLOAD"
        guard let url = URL(string: urlString) else {return }
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error  = error {
                print(error.localizedDescription)
            }else{
                DispatchQueue.main.async {
                    self.activityIndicator.isHidden = false
                    self.activityIndicator.startAnimating()
                }
                guard let data = data else {return}
                guard let jsonResult = try? JSONSerialization.jsonObject(with: data, options:.allowFragments) as? [String:Any] else {return }
                
                guard let jsonObject = jsonResult else {return}
                
                if let data = jsonObject["data"] as? [Array<Any>] {
                    for x in data {
                        var mainTitle = "Not Available"
                        var mainYear = "Not Available"
                        var mainLocation = "Not Available"
                        if let title = x[8] as? String {
                            mainTitle = title
                        }
                        if let year = x[9] as? String {
                            mainYear = year
                        }
                        
                        if let location = x[10] as? String {
                            mainLocation = location
                        }
                        
                        DispatchQueue.main.async {
                            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
                            let managedContext = appDelegate.persistentContainer.viewContext
                            
                            let movie = Movies(context: managedContext)
                            movie.title = mainTitle
                            movie.year = mainYear
                            movie.location = mainLocation
                            
                            do {
                                try managedContext.save()
                                self.movieArray.append(movie)
                            } catch let error as NSError{
                                print("Could not save",error.localizedDescription)
                            }
                        }

                    }
                }
                DispatchQueue.main.async {
                self.tableview.reloadData()
                self.activityIndicator.stopAnimating()
                self.activityIndicator.isHidden = true
                }
            }
        }.resume()
        self.check = false
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
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableview.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, shouldSpringLoadRowAt indexPath: IndexPath, with context: UISpringLoadedInteractionContext) -> Bool {
        return true
    }
    
    
    
    
}

