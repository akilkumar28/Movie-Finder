//
//  MapViewVC.swift
//  Movie Finder
//
//  Created by AKIL KUMAR THOTA on 9/30/17.
//  Copyright © 2017 Akil Kumar Thota. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MapViewVC: UIViewController,MKMapViewDelegate {

    @IBOutlet weak var descriptionTxt: UITextView!
    @IBOutlet weak var locationLbl: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    
    var movie:Movies?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let name = movie?.title {
            title = name
        }else {
            title = "Location"
        }
        mapView.delegate = self
        
        if let topItem = self.navigationController?.navigationBar.topItem {
            topItem.backBarButtonItem = UIBarButtonItem(title: "Back", style: UIBarButtonItemStyle.plain, target: nil, action: nil)
        }
        
        displayData()
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    
    //MARK: Normal Functions
    
    func displayData() {
        
        guard let address = movie?.location else {
            alert()
            return
            
        }
        let name = movie?.title ?? "Not available"
        locationLbl.text = name
        descriptionTxt.text = address
        let geoCoder = CLGeocoder()
        geoCoder.geocodeAddressString(address) { (placeMark, error) in
            if error != nil {
                self.alert()
                print(error!.localizedDescription)
            }
            guard let places = placeMark, let location = places.first?.location else {
                self.alert()
                return
            }
            
            let latitude = location.coordinate.latitude
            let longitude = location.coordinate.longitude
            
            DispatchQueue.main.async {
                self.setUpMapView(latVal:latitude,longVal:longitude)
            }
            
        }
        
    }
    
    
    func setUpMapView(latVal:CLLocationDegrees,longVal:CLLocationDegrees) {
        
        let latitude = latVal
        let longitude = longVal
        let latdelta:CLLocationDegrees = 0.01
        
        let londelta:CLLocationDegrees = 0.01
        
        let span:MKCoordinateSpan = MKCoordinateSpan(latitudeDelta: latdelta, longitudeDelta: londelta)
        
        let location:CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        
        let region:MKCoordinateRegion = MKCoordinateRegion(center: location, span: span)
        
        mapView.setRegion(region, animated: true)
        
        let annotation = MKPointAnnotation()
        
        annotation.coordinate = location
        
        annotation.title = movie?.location ?? "Not Available"
        let subtitle = movie?.title ?? "Not available"
        annotation.subtitle = "Movie Title: " + subtitle
        
        mapView.addAnnotation(annotation)
    }
    
    
    func alert(){
        let alertVC = UIAlertController(title: "Location Error", message: "The requested place cannont be displayed in the Map", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Dismiss", style: .cancel) { (action) in
            self.navigationController?.popViewController(animated: true)
        }
        alertVC.addAction(action)
        present(alertVC, animated: true, completion: nil)
    }
    

    
    
}
