//
//  ViewController.swift
//  MapsDemo
//
//  Created by Mohamed Sobhi  Fouda on 6/22/18.
//  Copyright © 2018 Mohamed Sobhi Fouda. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class ViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {

    let locationManager = CLLocationManager()
    
    // Perth, Scotland, United Kingdom to be changed to desired start location
    let myLatitude = 56.268547
    let myLongitude = -3.396567
    
    var currentLatitude: Double?
    var currentLongitude: Double?
    
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        locationManager.delegate = self
        mapView.delegate = self
        
        // Get current location
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
 
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let overlayRenderer = MKPolylineRenderer(overlay: overlay)
        overlayRenderer.strokeColor = .red
        overlayRenderer.lineWidth = 4.0
        
        return overlayRenderer
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error: " + error.localizedDescription)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        CLGeocoder().reverseGeocodeLocation(manager.location!) { (placemarks, error) in
            if (error != nil) {
                print("Error: " + error!.localizedDescription)
                return
            }
            if placemarks!.count > 0 {
                let placemark = placemarks![0] as CLPlacemark
                self.displayLocationDetails(placemark: placemark, location: manager.location!)
            } else {
                print("Error retrieving data")
            }
        }
    }
    
    func displayLocationDetails(placemark: CLPlacemark, location: CLLocation) {
        locationManager.stopUpdatingLocation()
        
        currentLatitude = location.coordinate.latitude
        currentLongitude  = location.coordinate.longitude
        
        // Draw Route
        let startLocation = CLLocationCoordinate2D(latitude: 56.268547, longitude: -3.396567)
        let endLocation = CLLocationCoordinate2D(latitude: currentLatitude!, longitude: currentLongitude!)
        
        let startPlacemark = MKPlacemark(coordinate: startLocation, addressDictionary: nil)
        let endPlacemark = MKPlacemark(coordinate: endLocation, addressDictionary: nil)
        
        let startMapItem = MKMapItem(placemark: startPlacemark)
        let endMapItem = MKMapItem(placemark: endPlacemark)
        
        let startAnnotation = MKPointAnnotation()
        startAnnotation.title = "Statue of Liberty National Monument"
        
        if let location = startPlacemark.location {
            startAnnotation.coordinate = location.coordinate
        }
        
        let endAnnotation = MKPointAnnotation()
        endAnnotation.title = "Empire State Building"
        
        if let location = endPlacemark.location {
            endAnnotation.coordinate = location.coordinate
        }
        
        mapView.showAnnotations([startAnnotation, endAnnotation], animated: true )
        
        let directionReq = MKDirectionsRequest()
        directionReq.source = startMapItem
        directionReq.destination = endMapItem
        directionReq.transportType = .automobile
        
        let directions = MKDirections(request: directionReq)
        
        directions.calculate {
            (res, err) -> Void in
            
            guard let res = res else {
                if let err = err {
                    print("Error: \(err)")
                }
                
                return
            }
            
            let route = res.routes[0]
            self.mapView.add((route.polyline), level: MKOverlayLevel.aboveRoads)
            
            let rect = route.polyline.boundingMapRect
            self.mapView.setRegion(MKCoordinateRegionForMapRect(rect), animated: true)
        }
        
    }


}

