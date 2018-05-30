//
//  AdvertisementInfoViewController.swift
//  JapanIceTea
//
//  Created by Ferdinando Mirra on 23/02/18.
//  Copyright © 2018 7App, iOSDA. All rights reserved.
//

import MapKit

class AdvertisementInfoViewController: UIViewController {

    @IBOutlet weak var adLocalPhoto: UIImageView!
    @IBOutlet weak var adLocalName: UILabel!
    @IBOutlet weak var adLocalAddress: UILabel!
    @IBOutlet weak var adDescription: UILabel!
   // var
    var advertisement: Ad!
    var fromMap = false

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.prefersLargeTitles = false
        self.navigationItem.title = advertisement.getTitle()
        //GM
      //  UserSingleton.shared.selectedBusinessLocalID = advertisement.businessLocalID
        
        self.adLocalPhoto.image = advertisement.getPhoto()
        self.adLocalName.text = advertisement.getSubtitle()
        self.adLocalAddress.text = advertisement.getAddress()
        self.adDescription.text = advertisement.getDetails()
    }

    override func viewWillAppear(_ animated: Bool) {
        print("ho selezionato il locale:\(advertisement.businessLocalID)")
        UserSingleton.shared.selectedBusinessLocalID = advertisement.businessLocalID
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if (fromMap == true) {
            self.navigationController?.navigationBar.prefersLargeTitles = false
        }
    }

    @IBAction func openInMaps(_ sender: UIButton) {

        let adLocalCoordinate = CLLocationCoordinate2DMake(advertisement.getLatitude(), advertisement.getLongitude())
        let placemark = MKPlacemark(coordinate: adLocalCoordinate)
        let location = MKMapItem(placemark: placemark)
        let launchOptions = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeWalking]
        
        location.openInMaps(launchOptions: launchOptions)
    }
    
}
