//
//  AdvertisementAnnotation.swift
//  JapanIceTea
//
//  Created by Ferdinando Mirra on 25/02/18.
//  Copyright © 2018 7App, iOSDA. All rights reserved.
//

import MapKit

class AdvertisementAnnotation: MKPointAnnotation {

    var advertisement: Ad?

    class func advertisements(fromAdvertisements advertisements: [Ad]) -> [AdvertisementAnnotation] {
        
        var advertisementAnnotations: [AdvertisementAnnotation] = []
        
        for advertisement in advertisements {
            
            let advertisementAnnotation = AdvertisementAnnotation()
            
            advertisementAnnotation.advertisement = advertisement
            advertisementAnnotation.title = advertisement.getTitle()
            advertisementAnnotation.subtitle = advertisement.getSubtitle()
            advertisementAnnotation.coordinate = CLLocationCoordinate2DMake(advertisement.getLatitude(), advertisement.getLongitude())
    
            advertisementAnnotations.append(advertisementAnnotation)
        }
        
        return advertisementAnnotations
    }

}
