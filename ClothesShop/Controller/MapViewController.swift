//
//  MapViewController.swift
//  ClothesShop
//
//  Created by ngovantucuong on 12/18/17.
//  Copyright © 2017 apple. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController,  MKMapViewDelegate {

    @IBOutlet var mapView: MKMapView!
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let identifier = "mypin"
        
        if annotation.isKind(of: MKUserLocation.self) {
            return nil
        }
        
        //reuse the annotation if possible
        var annotationView: MKPinAnnotationView? = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKPinAnnotationView
        
        if annotationView == nil {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView?.canShowCallout = true
        }
        
        let leftIconView = UIImageView(frame: CGRect(x: 0, y: 0, width: 53, height: 53))
        leftIconView.image = #imageLiteral(resourceName: "logoStore")
        annotationView?.leftCalloutAccessoryView = leftIconView
        annotationView?.pinTintColor = UIColor.orange
        
        return annotationView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        mapView.showsScale = true
        mapView.showsCompass = true
        mapView.showsTraffic = true
        
        // Do any additional setup after loading the view.
        //Convert address to coordinate and annotate it on map
        let geoCoder = CLGeocoder()
        let location = "723 Lạc Long Quân, Tân Bình, Hồ Chí Minh, Việt Nam"
        geoCoder.geocodeAddressString(location, completionHandler: {
            placemarks, error in
            if error != nil {
                print(error!)
                return
            }
            
            if let placemarks = placemarks {
                //get the first placemark
                let placemark = placemarks[0]
                
                //add annotation
                let annotation = MKPointAnnotation()
                annotation.title = "Bunny_Shop"
                annotation.subtitle = "The world's of you"
                if let location = placemark.location {
                    annotation.coordinate = location.coordinate
                    
                    //display the annotation
                    self.mapView.showAnnotations([annotation], animated: true)
                    self.mapView.selectAnnotation(annotation, animated: true)
                }
            }
        })
    }

}
