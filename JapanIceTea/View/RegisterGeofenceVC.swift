//
//  RegisterGeofenceVC.swift
//  testCloudkit
//
//  Created by giuseppe magnete on 23/02/18.
//  Copyright © 2018 giuseppe magnete. All rights reserved.
//

import UIKit
import CoreLocation

class RegisterGeofenceVC: UIViewController, ModelDelegate {
    var locationManager = CLLocationManager()
    
    func errorUpdating(error: NSError) {
        print("error")
    }
    
    func modelUpdated() {
        //registro le geonotification
        print("load terminato")
       registerGeofence()
        
    }
    

    var modelAdvertisement = AdvertisementModel.shared
   // var modelBusinessLocal = BusinessLocalModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.modelAdvertisement.delegate = self
        
        //location e distance fittizi
        modelAdvertisement.loadAdvertisementByRange(position: CLLocation(latitude: 40.13132142 , longitude: 12.3453424354), distance: 50)

       
        
    }
    func registerGeofence()
    {
        print("num. gefence:\(modelAdvertisement.nearAdvertisements.count)")
        for ad in modelAdvertisement.nearAdvertisements
        {
            print(ad.location.coordinate)
            print(ad.range)
            print(ad.name)
            print(ad.geofenceType)
            
            //modelBusinessLocal.loadBusinessLocalByID(ID: ad.businessLocal.recordID.recordName)
            var geotification = Geotification(coordinate: ad.location.coordinate, radius: Double(ad.range), identifier: "iuopopo", title: ad.name, message: ad.descr, eventType: ad.geofenceType)
         
             startMonitoring(geotification: geotification)
            print("avvio monitoring geotification")
        }
    }
    func region(withGeotification geotification: Geotification) -> CLCircularRegion {
        // 1
        let region = CLCircularRegion(center: geotification.coordinate, radius: geotification.radius, identifier: geotification.identifier)
        // 2
        region.notifyOnEntry = (geotification.eventType == "onEntry")
        region.notifyOnExit = !region.notifyOnEntry
        
        return region
    }
    
    func startMonitoring(geotification: Geotification) {
        // 1
        if !CLLocationManager.isMonitoringAvailable(for: CLCircularRegion.self) {
            showAlert(withTitle:"Error", message: "Geofencing is not supported on this device!")
            return
        }
        // 2
//        if CLLocationManager.authorizationStatus() == .authorizedAlways {
//            showAlert(withTitle:"Warning", message: "Your geotification is saved.")
//        }
        // 3
        let region = self.region(withGeotification: geotification)
        // 4
        locationManager.startMonitoring(for: region)
    }
    
    func stopMonitoring(geotification: Geotification) {
        for region in locationManager.monitoredRegions {
            guard let circularRegion = region as? CLCircularRegion, circularRegion.identifier == geotification.identifier else { continue }
            locationManager.stopMonitoring(for: circularRegion)
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
// MARK: - Location Manager Delegate
extension RegisterGeofenceVC: CLLocationManagerDelegate {
    

    
    func locationManager(_ manager: CLLocationManager, monitoringDidFailFor region: CLRegion?, withError error: Error) {
        print("Monitoring failed for region with identifier: \(region!.identifier)")
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location Manager failed with the following error: \(error)")
    }
    
}
