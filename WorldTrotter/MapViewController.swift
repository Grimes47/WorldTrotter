//
//  MapViewController.swift
//  WorldTrotter
//
//  Created by Adam Hogan on 6/5/17.
//  Copyright © 2017 Adam Hogan. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    var mapView: MKMapView!
    
    let locationManager = CLLocationManager()
    
    var annotationIndex = 0
    
    struct Location {
        let title: String
        let latitude: Double
        let longitude: Double
    }
    
    let locations = [
        Location(title: "Born Here", latitude: 33.763800, longitude: -117.899293),
        Location(title: "Live Here", latitude: 33.130043, longitude: -117.106317),
        Location(title: "Cool Place", latitude: 33.288006, longitude: -116.224744),
        ]
    
    var annotLocs: Array<MKPointAnnotation> = []
    
  
    override func loadView() {
        mapView = MKMapView()
        view = mapView
        
        
        let standardString = NSLocalizedString("Standard", comment: "Standard map view")
        let satelliteString = NSLocalizedString("Satellite", comment: "Satellite map view")
        let hybridString = NSLocalizedString("Hybrid", comment: "Hybrid map view")
        let segmentedControl = UISegmentedControl(items: [standardString, satelliteString, hybridString])
        
        segmentedControl.backgroundColor = UIColor.white.withAlphaComponent(0.5)
        segmentedControl.selectedSegmentIndex = 0
        
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(segmentedControl)
        
        let topConstraint = segmentedControl.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor, constant: 8)
        
        let margins = view.layoutMarginsGuide
        let leadingConstraint = segmentedControl.leadingAnchor.constraint(equalTo: margins.leadingAnchor)
        let trailingConstraint = segmentedControl.trailingAnchor.constraint(equalTo: margins.trailingAnchor)
        
        topConstraint.isActive = true
        leadingConstraint.isActive = true
        trailingConstraint.isActive = true
        
        segmentedControl.addTarget(self, action: #selector(MapViewController.mapTypeChanged(_:)), for: .valueChanged)
        
        initLocalizationButton(segmentedControl)
        
        pinButton(segmentedControl)
        
        for location in locations {
            let annotation = MKPointAnnotation()
            annotation.title = location.title
            annotation.coordinate = CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
            mapView.addAnnotation(annotation)
            annotLocs.append(annotation)
        }
        
    }
    
    func initLocalizationButton(_ anyView: UIView!){
        let localizationButton = UIButton.init(type: .system)
        localizationButton.setTitle("Localization", for: .normal)
        localizationButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(localizationButton)
        
        //Constraints
        
        let topConstraint = localizationButton.topAnchor.constraint(equalTo:anyView
            .topAnchor, constant: 32 )
        let leadingConstraint = localizationButton.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor)
        let trailingConstraint = localizationButton.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor)
        
        topConstraint.isActive = true
        leadingConstraint.isActive = true
        trailingConstraint.isActive = true
        
        localizationButton.addTarget(self, action: #selector(MapViewController.showLocalization(sender:)), for: .touchUpInside)
        
        
    }
    
    func pinButton(_ anyView: UIView!) {
        let pinButton = UIButton(type: .system)
        pinButton.setTitle("Cycle Pins", for: .normal)
        pinButton.backgroundColor = UIColor.white.withAlphaComponent(0.5)
        pinButton.frame = CGRect(x: 0, y: 0, width: 100, height: 50)
        pinButton.translatesAutoresizingMaskIntoConstraints = false
        pinButton.addTarget(self, action: #selector(selectPin(_:)), for: .touchUpInside)
        view.addSubview(pinButton)
        pinButton.bottomAnchor.constraint(equalTo: bottomLayoutGuide.topAnchor, constant: -8).isActive = true
        pinButton.leftAnchor.constraint(equalTo: view.layoutMarginsGuide.leftAnchor).isActive = true
    }
    
    func selectPin(_ anyView: UIView!) {
        if annotationIndex == annotLocs.count {
            annotationIndex = 0
        } else {
            let annotation = mapView.annotations[annotationIndex]
            let zoomedCurrentLocation = MKCoordinateRegionMakeWithDistance(annotation.coordinate, 5000, 5000)
            mapView.setRegion(zoomedCurrentLocation, animated: true)
            annotationIndex += 1
            print(annotLocs.count)
            print(annotationIndex)
        }
    }
   
    
    func mapTypeChanged(_ segControl: UISegmentedControl) {
        switch segControl.selectedSegmentIndex {
        case 0:
            mapView.mapType = .standard
        case 1:
            mapView.mapType = .hybrid
        case 2:
            mapView.mapType = .satellite
        default:
            break 
        }
    }
    
    func showLocalization(sender: UIButton!) {
        locationManager.requestWhenInUseAuthorization()
        mapView.showsUserLocation = true
        mapView.userTrackingMode = .follow
    }
    
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        //This is a method from MKMapViewDelegate, fires up when the user`s location changes
        let zoomedInCurrentLocation = MKCoordinateRegionMakeWithDistance(userLocation.coordinate, 500, 500)
        mapView.setRegion(zoomedInCurrentLocation, animated: true)
      
    }
    
    
}
