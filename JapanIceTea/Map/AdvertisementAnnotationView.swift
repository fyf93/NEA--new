//
//  AdvertisementAnnotationView.swift
//  JapanIceTea
//
//  Created by Ferdinando Mirra on 13/02/18.
//  Copyright © 2018 7App, iOSDA. All rights reserved.
//

import MapKit

class AdvertisementAnnotationView: MKAnnotationView {
    
    override var annotation: MKAnnotation? {

        willSet {
            self.bounds.size.width /= 6.0
            self.bounds.size.height /= 6.0
            self.centerOffset = CGPoint(x: 0, y: -40)
            self.canShowCallout = true

            /*
            let smallSquare = CGSize(width: 60, height: 60)
            let button = UIButton(frame: CGRect(origin: .zero, size: smallSquare))
            button.setImage(UIImage(named: "car"), for: .normal)
            self.rightCalloutAccessoryView = button
             */

            self.calloutOffset = CGPoint(x: -5, y: 5)
            self.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
    }
}
