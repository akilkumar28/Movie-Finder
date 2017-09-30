//
//  MovieCell.swift
//  Movie Finder
//
//  Created by AKIL KUMAR THOTA on 9/29/17.
//  Copyright © 2017 Akil Kumar Thota. All rights reserved.
//

import UIKit

class MovieCell: UITableViewCell {
    @IBOutlet weak var locationLbl: UILabel!
    
    @IBOutlet weak var titleLbl: UILabel!
    
    @IBOutlet weak var yearLbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    
    
    func configureCell(movie:Movie) {
        
        titleLbl.text = movie.title
        yearLbl.text = "\(movie.year)"
        locationLbl.text = movie.location
       
    }

    

}
