//
//  MapViewController.swift
//  JapanIceTea
//
//  Created by Ferdinando Mirra on 12/02/18.
//  Copyright © 2018 7App, iOSDA. All rights reserved.
//

import UIKit
import MapKit

protocol HandleMapSearch {
    func zoomIn(placemark: MKPlacemark)
}

class MapViewController: UIViewController, MKMapViewDelegate, HandleMapSearch, CLLocationManagerDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
//GM
    var modelAdvertisement = AdvertisementModel.shared
    var modelBusinessLocal = BusinessLocalModel.shared
//end GM
 /*   let locationManager: CLLocationManager = {
        let manager = CLLocationManager()
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
        return manager
    }()*/

    var resultSearchController: UISearchController? = nil
    var selectedPin: MKPlacemark? = nil
    var localityName: String = ""
    var location : CLLocationCoordinate2D?

    override func viewDidLoad() {
        super.viewDidLoad()
        //GM
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        location = appDelegate.locationManager.location?.coordinate
        
      /*let location = CLLocationCoordinate2DMake((locationManager.location?.coordinate.latitude)!,
                                               (locationManager.location?.coordinate.longitude)!)*/
        //end GM
        mapView.delegate = self
        mapView.mapType = .standard
        mapView.showsScale = true
        mapView.showsCompass = true
        mapView.isScrollEnabled = true
        mapView.showsUserLocation = false
        mapView.showsPointsOfInterest = false
        mapView.setUserTrackingMode(.follow, animated: true)
        
       //se non riesco ad ottenere la posizione corrente dell'utente (ad esempio se sto provando sul simulatore)
        if location == nil {
            print("Impossibile ottenere coordinate GPS, imposto posizione a Napoli!")
            //imposto come location iniziale Napoli centro
            location = CLLocationCoordinate2D(latitude: 40.836679, longitude: 14.306346)
        }

        let span = MKCoordinateSpanMake(0.05, 0.05)
        let region = MKCoordinateRegionMake(location!, span)
        mapView.setRegion(region, animated: true)
        
        setupNavigationBar()
        setupUserTrackingButton()
        setupLocationSearchTable()
        setupPointAnnotations()
        
    }
  
    
    func setupNavigationBar() {
        
        self.navigationController?.navigationBar.prefersLargeTitles = false
        
        let geoCoder = CLGeocoder()
        let location = CLLocation(latitude: mapView.centerCoordinate.latitude, longitude: mapView.centerCoordinate.longitude)
        geoCoder.reverseGeocodeLocation(location, completionHandler: { (placemarks, error) -> Void in
            guard let placeMark = placemarks?[0], let locality = placeMark.locality else {
                return
            }
            
            if self.localityName != locality {
// self.updateAnnotations(location: location)
                self.navigationItem.title = locality
                self.localityName = locality
            }
        })
    }
    
    func setupUserTrackingButton() {

        let button = MKUserTrackingButton(mapView: mapView)
        button.layer.backgroundColor = UIColor(white: 1, alpha: 0.8).cgColor
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 5
        button.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(button)

        NSLayoutConstraint.activate([button.bottomAnchor.constraint(equalTo: mapView.bottomAnchor, constant: -10),
                                     button.trailingAnchor.constraint(equalTo: mapView.trailingAnchor, constant: -10)])
    }
    
    func setupLocationSearchTable() {
        
        let locationSearchTable = storyboard!.instantiateViewController(withIdentifier: "LocationSearchTableViewController") as! LocationSearchTableViewController
        resultSearchController = UISearchController(searchResultsController: locationSearchTable)
        resultSearchController?.searchResultsUpdater = locationSearchTable

        let searchBar = resultSearchController!.searchBar
        searchBar.sizeToFit()
        searchBar.placeholder = "Search a place"
        navigationItem.titleView = resultSearchController?.searchBar
        
        resultSearchController?.hidesNavigationBarDuringPresentation = false
        resultSearchController?.dimsBackgroundDuringPresentation = true
        definesPresentationContext = true

        locationSearchTable.mapView = mapView
        locationSearchTable.handleMapSearchDelegate = self
    }

    func setupPointAnnotations() {
//GM
       // let advertisements = DatabaseManager.shared.getAdvertisements()
        while (modelAdvertisement.nearAdvertisements.count < 1) || (modelBusinessLocal.businessLocals.count < 1)
        {
            //print("wait server")
        }
        modelAdvertisement.CreateWrapperAdvertisement()
        let advertisements = AdvertisementModel.shared.wrapperAds
        print("numero annotation=\(advertisements.count)")
        
//end GM
        mapView.addAnnotations(AdvertisementAnnotation.advertisements(fromAdvertisements: advertisements))

        mapView.register(AdvertisementAnnotationView.self, forAnnotationViewWithReuseIdentifier: "advertisement")
/*
        let advertisements = DatabaseManager.shared.getAdvertisements()

        for advertisement in advertisements {

            let annotation = MKPointAnnotation()
            let annotationCoordinate = CLLocationCoordinate2DMake(advertisement.getLatitude(), advertisement.getLongitude())

            annotation.coordinate = annotationCoordinate
            annotation.title = advertisement.getTitle()
            annotation.subtitle = advertisement.getSubtitle()

            mapView.addAnnotation(annotation)
        }

        mapView.register(AdvertisementAnnotationView.self, forAnnotationViewWithReuseIdentifier: "advertisement")

        let annotation1 = MKPointAnnotation()
        let annotationCoordinate1 = CLLocationCoordinate2DMake(40.853294, 14.305573)
        annotation1.coordinate = annotationCoordinate1
        annotation1.title = "Ferdinando"
        annotation1.subtitle = "An Italian is here!"
        mapView.addAnnotation(annotation1)
        
        let annotation2 = MKPointAnnotation()
        let annotationCoordinate2 = CLLocationCoordinate2DMake(40.855294, 14.302573)
        annotation2.coordinate = annotationCoordinate2
        annotation2.title = "Paul"
        annotation2.subtitle = "An English is here!"
        mapView.addAnnotation(annotation2)

        let annotation3 = MKPointAnnotation()
        let annotationCoordinate3 = CLLocationCoordinate2DMake(40.851294, 14.309573)
        annotation3.coordinate = annotationCoordinate3
        annotation3.title = "Juan"
        annotation3.subtitle = "A Spanish is here!"
        mapView.addAnnotation(annotation3)
        
        let annotation4 = MKPointAnnotation()
        let annotationCoordinate4 = CLLocationCoordinate2DMake(40.852112, 14.305212)
        annotation4.coordinate = annotationCoordinate4
        annotation4.title = "Peace"
        annotation4.subtitle = "A freak is here!"
        mapView.addAnnotation(annotation4)

        let annotation5 = MKPointAnnotation()
        let annotationCoordinate5 = CLLocationCoordinate2DMake(40.836459, 14.239286)
        annotation5.coordinate = annotationCoordinate5
        annotation5.title = "Baretti San Pasquale"
        annotation5.subtitle = "Today all you can drink!"
        mapView.addAnnotation(annotation5)

        let annotation6 = MKPointAnnotation()
        let annotationCoordinate6 = CLLocationCoordinate2DMake(40.813117, 14.166688)
        annotation6.coordinate = annotationCoordinate6
        annotation6.title = "Arenile di Bagnoli"
        annotation6.subtitle = "Tonight latin dance!"
        mapView.addAnnotation(annotation6)

        let annotation7 = MKPointAnnotation()
        let annotationCoordinate7 = CLLocationCoordinate2DMake(40.842514, 14.247273)
        annotation7.coordinate = annotationCoordinate7
        annotation7.title = "Nennella"
        annotation7.subtitle = "Today gnocchi and meatballs!"
        mapView.addAnnotation(annotation7)

        mapView.register(AdvertisementAnnotationView.self, forAnnotationViewWithReuseIdentifier: "advertisement")
*/
    }
    
    func zoomIn(placemark: MKPlacemark) {
        
        selectedPin = placemark

//        mapView.removeAnnotations(mapView.annotations)
//
//        let annotation = MKPointAnnotation()
//        annotation.coordinate = placemark.coordinate
//        annotation.title = placemark.name
//        if let city = placemark.locality, let state = placemark.administrativeArea {
//            annotation.subtitle = "\(city), \(state)"
//        }
//
//        mapView.addAnnotation(annotation)
        
        let span = MKCoordinateSpanMake(0.10, 0.10)
        let region = MKCoordinateRegionMake(placemark.coordinate, span)
        mapView.setRegion(region, animated: true)
    }

    // MARK: - Map view methods

// Viene invocata quando cambia la regione
// Bisogna aggiornare anche le annotationi
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        setupNavigationBar()
       // debugPrint("regionDidChangeAnimated - locality: \(localityName)")
    }

// Viene invocata quando startAction imposta showsUserLocation a true
    func mapViewWillStartLocatingUser(_ mapView: MKMapView) {
        debugPrint("mapViewWillStartLocatingUser")
    }

    func startAction(_ sender: UIButton) {
        mapView.showsUserLocation = true
    }

// Viene invocata quando stopAction imposta showsUserLocation a false
    func mapViewDidStopLocatingUser(_ mapView: MKMapView) {
        debugPrint("mapViewDidStopLocatingUser")
    }

    func stopAction(_ sender: UIButton) {
        mapView.showsUserLocation = false
    }

// Viene invocata quando cambia la posizione dell'utente
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
      //  debugPrint("didUpdate - latitude: \(userLocation.coordinate.latitude), longitude: \(userLocation.coordinate.longitude)")
    }

    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {

        if control == view.rightCalloutAccessoryView {
            performSegue(withIdentifier: "advertisementMapInfo", sender: view)
        }
    }

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {

        if annotation is MKUserLocation {
            return nil // return nil so map view draws "blue dot" for standard user location
        }
/*
        let idDefaultAnnotation = MKMapViewDefaultAnnotationViewReuseIdentifier

        if let pinView = mapView.dequeueReusableAnnotationView(withIdentifier: idDefaultAnnotation, for: annotation) as? MKMarkerAnnotationView {

            if let title = annotation.title, title == "Ferdinando" {

                pinView.titleVisibility = .visible
                pinView.subtitleVisibility = .visible
                pinView.displayPriority = .required
                pinView.markerTintColor = .white
                pinView.glyphTintColor = .black
                pinView.glyphText = "🇮🇹"

                return pinView

            } else if let title = annotation.title, title == "Paul" {
                
                pinView.titleVisibility = .visible
                pinView.subtitleVisibility = .visible
                pinView.displayPriority = .required
                pinView.markerTintColor = .white
                pinView.glyphTintColor = .black
                pinView.glyphText = "🇬🇧"
                
                return pinView

            } else if let title = annotation.title, title == "Juan" {
                
                pinView.titleVisibility = .visible
                pinView.subtitleVisibility = .visible
                pinView.displayPriority = .required
                pinView.markerTintColor = .white
                pinView.glyphTintColor = .black
                pinView.glyphText = "🇪🇸"
                
                return pinView
                
            } else if let title = annotation.title, title == "Peace" {
                
                pinView.titleVisibility = .visible
                pinView.subtitleVisibility = .visible
                pinView.displayPriority = .required
                pinView.markerTintColor = .white
                pinView.glyphTintColor = .black
                pinView.glyphText = "🏳️‍🌈"
                
                return pinView
                
            }

        }
*/
        let idCustomAnnotation = "advertisement"
        
        if let pinView = mapView.dequeueReusableAnnotationView(withIdentifier: idCustomAnnotation, for: annotation) as? AdvertisementAnnotationView {

            if let title = annotation.title, title == "Bar" {

                pinView.image = #imageLiteral(resourceName: "red")
                pinView.displayPriority = .required
                
                return pinView

            } else if let title = annotation.title, title == "Disco" {
                
                pinView.image = #imageLiteral(resourceName: "purple")
                pinView.displayPriority = .required
                
                return pinView
                
            } else if let title = annotation.title, title == "Restaurant" {
                
                pinView.image = #imageLiteral(resourceName: "green")
                pinView.displayPriority = .required
                
                return pinView
            }
        }
        
        return nil
    }

    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "advertisementMapInfo" {

            let destination = segue.destination as! AdvertisementInfoViewController
            let view = sender as! AdvertisementAnnotationView

            destination.fromMap = true
            destination.advertisement = (view.annotation as! AdvertisementAnnotation).advertisement
        }
    }

}
