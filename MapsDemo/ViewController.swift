//
//  ViewController.swift
//  MapsDemo
//
//  Created by Mohamed Sobhi  Fouda on 6/22/18.
//  Copyright © 2018 Mohamed Sobhi Fouda. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let location = CLLocationCoordinate2D(
            latitude: 37.3092293,
            longitude: -122.1136845
        )
        
        let span = MKCoordinateSpanMake(0.3, 0.3)
        let region = MKCoordinateRegion(center: location, span: span)
        mapView.setRegion(region, animated: true)
        
        // Add Annotation
        let annotation = MKPointAnnotation()
        annotation.coordinate = location
        annotation.title = "Infinite Loop"
        annotation.subtitle = "Apple HQ"
        mapView.addAnnotation(annotation)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

