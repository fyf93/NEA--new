//
//  LoadPreviousAdvertisementTableViewController.swift
//  JapanIceTea
//
//  Created by Giuseppe Magnete on 19/02/18.
//  Copyright © 2018 7App, iOSDA. All rights reserved.
//

import UIKit

class LoadPreviousAdvertisementTableViewController: UITableViewController, ModelDelegate {

    var model = AdvertisementModel.shared

    override func viewDidLoad() {
        super.viewDidLoad()
        self.model.delegate = self
        self.tableView.reloadData()
        loadPreviousAdvertisement()
    }

    func loadPreviousAdvertisement()
    {
        model.loadAdvertisementByOwner()
    }
    
    func errorUpdating(error: NSError) {
        print("error LoadPreviousAdvertisementTableViewController")
    }
    
    func modelUpdated() {
        print("modelUpdated LoadPreviousAdvertisementTableViewController")
        self.tableView.reloadData()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return OwnerSingleton.advertisements.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "previousAdvertisement", for: indexPath)
        
        cell.textLabel?.text = OwnerSingleton.advertisements[indexPath.row].name
        cell.detailTextLabel?.text = OwnerSingleton.advertisements[indexPath.row].descr

        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        OwnerSingleton.idxAdvertisementSelected = indexPath.row
        self.performSegue(withIdentifier: "returnNewAdvertisement", sender: self)
    }

}
