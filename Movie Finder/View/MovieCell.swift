//
//  MovieCell.swift
//  Movie Finder
//
//  Created by AKIL KUMAR THOTA on 9/29/17.
//  Copyright © 2017 Akil Kumar Thota. All rights reserved.
//

import UIKit
import CoreData

class MovieCell: UITableViewCell {
    
    //MARK: IBOutlets
    @IBOutlet weak var designView: UIView!
    @IBOutlet weak var locationLbl: UILabel!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var yearLbl: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        designView.layer.cornerRadius = 5
        designView.layer.shadowColor = UIColor.black.cgColor
        designView.layer.shadowRadius = 5
        designView.layer.shadowOpacity = 0.7
        designView.layer.shadowOffset = CGSize.zero
    }
    
    //MARK: Functions

    func configureCell(movie:NSManagedObject) {
        let mainTitle = movie.value(forKey: "title") as? String
        titleLbl.text = mainTitle ?? "Not available"
        let year = movie.value(forKey: "year") as? String
        yearLbl.text = year ?? "Not available"
        let location = movie.value(forKey: "location") as? String
        locationLbl.text = location ?? "Not available"
       
    }
}
