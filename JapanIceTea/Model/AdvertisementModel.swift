//
//  AdvertisementModel.swift
//  testCloudkit
//
//  Created by giuseppe magnete on 19/02/18.
//  Copyright © 2018 giuseppe magnete. All rights reserved.
//

import UIKit
import Foundation
import CloudKit

class AdvertisementModel {
    static let shared = AdvertisementModel()
    var container: CKContainer
    var publicDB : CKDatabase
    let privateDB  : CKDatabase
    var delegate : ModelDelegate?
    var nearAdvertisements = [Advertisement]()
    var advertisementsByBL = [Advertisement]()
    //array che contiente advertisement recuperati dal database convertiti nel formato previsto dall'interfaccia grafica
    var wrapperAds = [Ad]()
    
    func CreateWrapperAdvertisement()
    {
        let modelBusinessLocal = BusinessLocalModel.shared
        print("annunci=\(nearAdvertisements.count)")
        for ad in nearAdvertisements
        {
            let id = ad.record.recordID.recordName
            let businessLocal = modelBusinessLocal.findBusinessLocal(ID: ad.businessLocal.recordID.recordName)
           // print(id)
           // print(businessLocal?.type)
            print(businessLocal?.name)
            //print(ad.descr)
            //print(ad.dateTime)
            //print(businessLocal?.address)
            print(businessLocal?.location.coordinate.latitude)
            print(businessLocal?.location.coordinate.longitude)
            
            let advertisement = Ad(id: id, title: (businessLocal?.type)!, subtitle: ad.name, details: ad.descr, date: ad.dateTime, address: (businessLocal?.address)!, latitude: (businessLocal?.location.coordinate.latitude)!, longitude: (businessLocal?.location.coordinate.longitude)!, photo: businessLocal!.mainPhoto.toUIImage()!, businessLocalID: ad.businessLocal.recordID.recordName, localName: (businessLocal?.name)!
            )
            wrapperAds.append(advertisement)
        }
    }
    func getAdvertisements(forType type: String) -> [Ad] {
        var results: [Ad] = []
        for advertisement in self.wrapperAds {
            //print("type=\(advertisement.getTitle())")
            if advertisement.getTitle() == type {
                results.append(advertisement)
            }
        }
        return results
    }
    
    
    private init(){
        container = CKContainer.default()
        publicDB = container.publicCloudDatabase
        privateDB = container.privateCloudDatabase
    }
    
    func saveAdvertisement(name: String, descr : String, dateTime: Date, day: String, time: String, oneTimeEvent: Int, owner: CKReference, businessLocal: CKReference, location: CLLocation)
    {
        let adRecord = CKRecord(recordType: "Advertisement")
        adRecord.setValue(name, forKey: "name")
        adRecord.setValue(descr, forKey: "description")
        adRecord.setValue(dateTime, forKey: "dateTime")
        adRecord.setValue(day, forKey: "day")
        adRecord.setValue(time, forKey: "time")
        adRecord.setValue(oneTimeEvent, forKey: "oneTimeEvent")
        adRecord.setValue(owner, forKey: "owner")
        adRecord.setValue(businessLocal, forKey: "businessLocal")
        adRecord.setValue("onEntry", forKey: "geofenceType")
        adRecord.setValue(15, forKey: "range")
        adRecord.setValue(location, forKey: "location")
        self.publicDB.save(adRecord) { (record, error) -> Void in
            if (error != nil)
            {
                print("error save Advertisement:\(error)")
                DispatchQueue.main.async() {
                    self.delegate?.errorUpdating(error: error! as NSError)
                    return
                }            }
            else
            {
                print("Advertisement Saved")
                DispatchQueue.main.async() {
                    self.delegate?.modelUpdated()
                    return
                }
            }
            
        }
        
    }
    
    func loadAdvertisementByRange(position: CLLocation, distance: Int)
    {
        let predicate = NSPredicate(value: true)
        let query = CKQuery(recordType: "Advertisement", predicate: predicate)
        publicDB.perform(query, inZoneWith: nil) { (results, error) in
            if error != nil
            {
                print("error: \(error)")
                DispatchQueue.main.async() {
                    self.delegate?.errorUpdating(error: error! as NSError)
                    return
                }
            }
            else
            {
                self.nearAdvertisements.removeAll()
                for record in results!
                {
                    let ad = Advertisement(record: record as CKRecord, database: self.publicDB)
                    print("aggiungo \(ad.name) all'elenco")
                   self.nearAdvertisements.append(ad)
                   
                }
            }
            DispatchQueue.main.async() {
                print("end loadAdvertisementByRange")
                self.delegate?.modelUpdated()
                return
            }
        }
        
        
    }
    
    func loadAdvertisementByBusinessLocal(businessLocalID: String)
    {
     //   pri
        let predicate = NSPredicate(format: "businessLocal == %@", businessLocalID)
        let queryAdvertisement = CKQuery(recordType: "Advertisement", predicate: predicate)
        
        publicDB.perform(queryAdvertisement, inZoneWith: nil) { (results, error) in
            
            if error != nil
            {
                print("error: \(error)")
                DispatchQueue.main.async() {
                    self.delegate?.errorUpdating(error: error! as NSError)
                    return
                }
            }
            else
            {
                print("inizio query")
                self.advertisementsByBL.removeAll()
                for record in results!
                {
                    
                    let advertiser = Advertisement(record: record as CKRecord, database: self.publicDB)
                    print("recod letto \(advertiser.name)")
                    self.advertisementsByBL.append(advertiser)
                }
            }
            DispatchQueue.main.async() {
                print("async")
                self.delegate?.modelUpdated()
                return
            }
        }
    }
    
    func loadAdvertisementByOwner()
    {
        
        let predicate = NSPredicate(format: "owner == %@", OwnerSingleton.refOwner!)
        let queryAdvertisement = CKQuery(recordType: "Advertisement", predicate: predicate)
        
        publicDB.perform(queryAdvertisement, inZoneWith: nil) { (results, error) in
            
            if error != nil
            {
                print("error: \(error)")
                DispatchQueue.main.async() {
                    self.delegate?.errorUpdating(error: error! as NSError)
                    return
                }
            }
            else
            {
                OwnerSingleton.advertisements.removeAll()
                for record in results!
                {
                    let advertiser = Advertisement(record: record as CKRecord, database: self.publicDB)
                    print("carico annuncio:\(advertiser.name)")
                    OwnerSingleton.advertisements.append(advertiser)
                }
            }
            DispatchQueue.main.async() {
                print("async")
                self.delegate?.modelUpdated()
                return
            }
        }
    }
}
extension CKAsset {
    func toUIImage() -> UIImage? {
        if let data = NSData(contentsOf: self.fileURL) {
            return UIImage(data: data as Data)
        }
        return nil
    }
}
