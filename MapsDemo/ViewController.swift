//
//  ViewController.swift
//  MapsDemo
//
//  Created by Mohamed Sobhi  Fouda on 6/22/18.
//  Copyright © 2018 Mohamed Sobhi Fouda. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController, MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
//
//        let location = CLLocationCoordinate2D(
//            latitude: 37.3092293,
//            longitude: -122.1136845
//        )
//
//        let span = MKCoordinateSpanMake(0.3, 0.3)
//        let region = MKCoordinateRegion(center: location, span: span)
//        mapView.setRegion(region, animated: true)
//
//        // Add Annotation
//        let annotation = MKPointAnnotation()
//        annotation.coordinate = location
//        annotation.title = "Infinite Loop"
//        annotation.subtitle = "Apple HQ"
//        mapView.addAnnotation(annotation)
        
        // Draw Route
        mapView.delegate = self
        
        let startLocation = CLLocationCoordinate2D(latitude: 40.6892494, longitude: -74.0466891)
        let endLocation = CLLocationCoordinate2D(latitude: 40.7484405, longitude: -73.9878531)
        
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


}

