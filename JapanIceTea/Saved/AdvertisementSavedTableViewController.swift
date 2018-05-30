//
//  AdvertisementSavedTableViewController.swift
//  JapanIceTea
//
//  Created by Ferdinando Mirra on 22/02/18.
//  Copyright © 2018 7App, iOSDA. All rights reserved.
//

import UIKit

class AdvertisementSavedTableViewController: UITableViewController {

    var bookmarks: [Ad] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        self.clearsSelectionOnViewWillAppear = true
        self.tableView.tableFooterView = UIView()
       // self.bookmarksAdvertisementModel.shared.wrapperAds.first!)
         self.bookmarks.append(AdvertisementModel.shared.wrapperAds.first!)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
       // self.bookmarks.removeAll()
       
        self.tableView.reloadData()
    }

    // MARK: - Table view methods

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.bookmarks.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "advertisementSavedTableViewCell", for: indexPath) as! AdvertisementSavedTableViewCell

        cell.adLocalPhoto.image = bookmarks[indexPath.row].getPhoto()
        cell.adLocalName.text = bookmarks[indexPath.row].getSubtitle()
        cell.adLocalType.text = bookmarks[indexPath.row].getLocalName()

        return cell
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
          //GM
         /*   DatabaseManager.shared.removeBookmark(advertisement: bookmarks[indexPath.row])
            self.bookmarks = DatabaseManager.shared.getBookmarks()
             */
            //self.bookmarks
            self.tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }

    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        if segue.identifier == "advertisementSavedInfo" {

            if let indexPath = tableView.indexPathForSelectedRow {
                let selectedRow = indexPath.row
                let destination = segue.destination as? AdvertisementInfoViewController
                destination?.advertisement = bookmarks[selectedRow]
                destination?.hidesBottomBarWhenPushed = true
            }
        }
    }

}
