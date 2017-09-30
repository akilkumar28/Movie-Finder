//
//  Movie.swift
//  Movie Finder
//
//  Created by AKIL KUMAR THOTA on 9/29/17.
//  Copyright © 2017 Akil Kumar Thota. All rights reserved.
//

import Foundation


class Movie {
    
    private var _title:String!
    private var _year:Int!
    private var _location:String!
    
    
    
    var title:String {
        get {
           return self._title
        }
        set{
            self._title = newValue
        }
    }
    
    var year:Int {
        get {
            return self._year
        }
        set{
            self._year = newValue
        }
    }
    
    var location:String {
        get {
            return self._location
        }
        set{
            self._location = newValue
        }
    }
    
    
    init(title:String,year:Int,location:String) {
        self.title = title
        self.year = year
        self.location = location
    }
    
    
}
