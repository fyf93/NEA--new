//
//  OwnerHomeViewController.swift
//  JapanIceTea
//
//  Created by Giuseppe Magnete on 14/02/18.
//  Copyright © 2018 7App, iOSDA. All rights reserved.
//

import UIKit

class OwnerHomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, ModelDelegate {
    func errorUpdating(error: NSError) {
        print("error lista Business")
    }
    
    func modelUpdated() {
        print("Caricamento lista locali effettuato")
        self.tableViewAdvertisements.reloadData()
    }
    
    var advertisementModel = AdvertisementModel.shared
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return advertisementModel.advertisementsByBL.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "advertisementCell")
        cell?.textLabel?.text = advertisementModel.advertisementsByBL[indexPath.row].name
        cell?.detailTextLabel?.text = advertisementModel.advertisementsByBL[indexPath.row].descr
        
        return cell!
    }
    

    
    @IBOutlet weak var tableViewAdvertisements: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableViewAdvertisements.delegate = self
        self.tableViewAdvertisements.dataSource = self
        print("invocazione")
       /* advertisementModel.loadAdvertisementByBusinessLocal(businessLocalID: OwnerSingleton.businessLocals[OwnerSingleton.idxBusinessLocalSelected].record.recordID.recordName)
        /*
        print("IL proprietario ha registrato \(OwnerSingleton.businessLocals.count) locali")
        if (OwnerSingleton.businessLocals.count < 2) {
            print("nascondo back")
            self.navigationController?.navigationItem.hidesBackButton = true
        }
        */
  */  }

}

