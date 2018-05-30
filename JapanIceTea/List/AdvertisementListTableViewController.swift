//
//  AdvertisementListTableViewController.swift
//  JapanIceTea
//
//  Created by Ferdinando Mirra on 23/02/18.
//  Copyright © 2018 7App, iOSDA. All rights reserved.
//

import UIKit
struct EventType{
        static let bar = "Bar"
        static let disco = "Disco"
        static let restaurant = "Restaurant"    
}
class AdvertisementListTableViewController: UITableViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    var modelAdvertisement = AdvertisementModel.shared
    @IBOutlet weak var barCollectionView: UICollectionView!
    @IBOutlet weak var discoCollectionView: UICollectionView!
    @IBOutlet weak var restaurantCollectionView: UICollectionView!
    
//    var advertisementsBar = DatabaseManager.shared.getAdvertisements(forType: "Bar")
//    var advertisementsDisco = DatabaseManager.shared.getAdvertisements(forType: "Disco")
//    var advertisementsRestaurant = DatabaseManager.shared.getAdvertisements(forType: "Restaurant")
    var advertisementsBar = [Ad]()
    var advertisementsDisco = [Ad]()
    var advertisementsRestaurant = [Ad]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        
        self.advertisementsBar = modelAdvertisement.getAdvertisements(forType: EventType.bar)
        self.advertisementsDisco = modelAdvertisement.getAdvertisements(forType: EventType.disco)
        self.advertisementsRestaurant = modelAdvertisement.getAdvertisements(forType: EventType.restaurant)
        barCollectionView.delegate = self
        barCollectionView.dataSource = self

        discoCollectionView.delegate = self
        discoCollectionView.dataSource = self
        
        restaurantCollectionView.delegate = self
        restaurantCollectionView.dataSource = self
    }

    // MARK: - Table view methods

    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40.0
    }
    
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        
        let header = view as! UITableViewHeaderFooterView
        
        header.textLabel?.textColor = UIColor.white
        header.textLabel?.font = UIFont.systemFont(ofSize: 30, weight: UIFont.Weight.light)
        header.textLabel?.frame = header.frame
        header.textLabel?.textAlignment = NSTextAlignment.left
        
    }

    // MARK: - Collection view methods

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        switch collectionView {

            case barCollectionView:
                return advertisementsBar.count

            case discoCollectionView:
                return advertisementsDisco.count

            case restaurantCollectionView:
                return advertisementsRestaurant.count

            default:
                return 0
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let barCell: AdvertisementBarCollectionViewCell
        let discoCell: AdvertisementDiscoCollectionViewCell
        let restaurantCell: AdvertisementRestaurantCollectionViewCell
        
        let barCellId = "advertisementBarCollectionViewCell"
        let discoCellId = "advertisementDiscoCollectionViewCell"
        let restaurantCellId = "advertisementRestaurantCollectionViewCell"

        switch collectionView {
            
            case barCollectionView:
                barCell = collectionView.dequeueReusableCell(withReuseIdentifier: barCellId, for: indexPath) as! AdvertisementBarCollectionViewCell
                // barCell.adLocalPhoto.setBackgroundImage(advertisementsBar[indexPath.row].getLocalPhoto(), for: .normal)
                // barCell.adLocalName.text = advertisementsBar[indexPath.row].getLocalName()
                barCell.adLocalPhoto.setBackgroundImage(advertisementsBar[indexPath.row].getPhoto(), for: .normal)
                barCell.adLocalName.text = advertisementsBar[indexPath.row].getSubtitle()
                return barCell

            case discoCollectionView:
                discoCell = collectionView.dequeueReusableCell(withReuseIdentifier: discoCellId, for: indexPath) as! AdvertisementDiscoCollectionViewCell
                // discoCell.adLocalPhoto.setBackgroundImage(advertisementsDisco[indexPath.row].getLocalPhoto(), for: .normal)
                // discoCell.adLocalName.text = advertisementsDisco[indexPath.row].getLocalName()
                discoCell.adLocalPhoto.setBackgroundImage(advertisementsDisco[indexPath.row].getPhoto(), for: .normal)
                discoCell.adLocalName.text = advertisementsDisco[indexPath.row].getSubtitle()
                return discoCell
            
            case restaurantCollectionView:
                restaurantCell = collectionView.dequeueReusableCell(withReuseIdentifier: restaurantCellId, for: indexPath) as! AdvertisementRestaurantCollectionViewCell
                // discoCell.adLocalPhoto.setBackgroundImage(advertisementsRestaurant[indexPath.row].getLocalPhoto(), for: .normal)
                // discoCell.adLocalName.text = advertisementsRestaurant[indexPath.row].getLocalName()
                restaurantCell.adLocalPhoto.setBackgroundImage(advertisementsRestaurant[indexPath.row].getPhoto(), for: .normal)
                restaurantCell.adLocalName.text = advertisementsRestaurant[indexPath.row].getSubtitle()
                return restaurantCell

            default:
                return UICollectionViewCell()
        }
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        switch collectionView {

            case barCollectionView:
                self.performSegue(withIdentifier: "advertisementBarInfo", sender: indexPath)

            case discoCollectionView:
                self.performSegue(withIdentifier: "advertisementDiscoInfo", sender: indexPath)

            case restaurantCollectionView:
                self.performSegue(withIdentifier: "advertisementRestaurantInfo", sender: indexPath)

            default: return
        }
    }

    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "advertisementBarInfo" {

            let selectedIndexPath = sender as? NSIndexPath
            let destination = segue.destination as! AdvertisementInfoViewController
            destination.advertisement = advertisementsBar[(selectedIndexPath?.row)!]

        } else if segue.identifier == "advertisementDiscoInfo" {
            
            let selectedIndexPath = sender as? NSIndexPath
            let destination = segue.destination as! AdvertisementInfoViewController
            destination.advertisement = advertisementsDisco[(selectedIndexPath?.row)!]

        } else if segue.identifier == "advertisementRestaurantInfo" {
            
            let selectedIndexPath = sender as? NSIndexPath
            let destination = segue.destination as! AdvertisementInfoViewController
            destination.advertisement = advertisementsRestaurant[(selectedIndexPath?.row)!]
        }
    }

}
