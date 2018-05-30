//
//  CloudController.swift
//  testCloudkit
//
//  Created by giuseppe magnete on 25/01/18.
//  Copyright © 2018 giuseppe magnete. All rights reserved.
//

import UIKit
import Foundation
import CloudKit


class BusinessLocalModel {
    var container: CKContainer
    var publicDB : CKDatabase
    let privateDB: CKDatabase
    var businessLocals = [BusinessLocal]()
    var businessLocal : BusinessLocal?
    var delegate : ModelDelegate?
    static let shared = BusinessLocalModel()
    
    private init(){
        container = CKContainer.default()
        publicDB = container.publicCloudDatabase
        privateDB = container.privateCloudDatabase
    }
    
    func findBusinessLocal(ID: String) -> BusinessLocal?
    {
        for bl in self.businessLocals
        {
            //print("bl = \(bl.record.recordID.recordName)")
            if (bl.record.recordID.recordName == ID)
            {
                return bl
            }
        }
        return nil
    }
    
    func loadBusinessLocalByID(ID: String)
    {
        let recordId = CKRecordID(recordName: ID)
        CKContainer.default().publicCloudDatabase.fetch(withRecordID: recordId) { record, error in
            if error != nil {
                return
            }
            self.businessLocal = BusinessLocal(record: record!, database: self.publicDB)
        }
    }
    
    func loadBusinessLocals()
    {
        let predicate = NSPredicate(value: true)
        let query = CKQuery(recordType: "BusinessLocal", predicate: predicate)
        publicDB.perform(query, inZoneWith: nil) { (results, error) -> Void in
            if error != nil
            {
                DispatchQueue.main.async() {
                    self.delegate?.errorUpdating(error: error! as NSError)
                    return
                }
            }
            else
            {
                self.businessLocals.removeAll(keepingCapacity: true)
                for record in results!
                {
                    let bLocal = BusinessLocal(record: record as CKRecord, database: self.publicDB)
                    self.businessLocals.append(bLocal)
                    print("load locale= \(bLocal.name)")
                    //OwnerSingleton.businessLocals.append(bLocal)
                    
                }
            }
            DispatchQueue.main.async() {
                self.delegate?.modelUpdated()
                return
            }
        }
    }

 //salva un locale su cloudkit. Verifico se non c'è già un locale con lo stesso nome registrato (e se l'ha registrato lo stesso proprietario o qualcun altro)
func saveBusinessLocal(name: String, address: String, descr : String, location : CLLocation, type: String, approved: String, mainPhoto: UIImage, owner: CKReference)
    {
    //verifico se nel db ci sono già attività con lo stesso nome, per evitare che un owner registri 2 volte il suo locale
        let predicate = NSPredicate(format: "name == %@", name)
        let query = CKQuery(recordType: "BusinessLocal", predicate: predicate)
        publicDB.perform(query, inZoneWith: nil) { (results, error) in
            if error != nil
            {
                print("error check name BusinessLocal: \(error)")
                DispatchQueue.main.async() {
                    self.delegate?.errorUpdating(error: error! as NSError)
                    return
                }
            }
            else
            {
                if (results?.isEmpty == false)
                {
                     var message = String()
                    for record in results!
                    {
                        let businessLocal = BusinessLocal(record: record as CKRecord, database: self.publicDB)
                        //verifico se l'attività già esistente è stata creata dal proprietario attualmente connesso
                        if (businessLocal.owner == OwnerSingleton.refOwner)
                        {
                            message = "creata da te!"
                        }
                        else
                        {
                            message = "creata da un altro utente!"
                        }
                    }
                    let er = NSError(domain: "Già esiste un'attività con questo nome, \(message)", code: 1, userInfo: nil)
                   
                    DispatchQueue.main.async() {
                        self.delegate?.errorUpdating(error: er as NSError)
                        return
                    }
                }
                else
                {//se non ci sono altre attività con lo stesso name, procedo al salvataggio
                    
                    //var mainPhoto : UIImage  = getImageWithColor(color: UIColor.black, size: CGSize(width: 40, height: 40))
                    let data = UIImagePNGRepresentation(mainPhoto);
                    let url = NSURL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(NSUUID().uuidString+".dat")
                    do {
                        try data?.write(to: url!)
                    } catch let e as NSError {
                        print("Error! \(e)");
                        return
                    }
                    let newPhoto = CKAsset(fileURL: url!)
                    print ("Image saved")
                    let blRecord = CKRecord(recordType: "BusinessLocal")
                    blRecord.setValue(name,     forKey: "name")
                    blRecord.setValue(descr,    forKey: "description")
                    blRecord.setValue(address,  forKey: "address")
                    blRecord.setValue(location, forKey: "location")
                    blRecord.setValue(type,     forKey: "type")
                    blRecord.setValue(approved, forKey: "approved")
                    blRecord.setValue(newPhoto, forKey: "mainPhoto")
                    blRecord.setValue(owner, forKey: "owner")
                    
                    self.publicDB.save(blRecord) { (record, error) -> Void in
                        if (error != nil)
                        {
                            print("error save \(error)")
                            DispatchQueue.main.async() {
                                self.delegate?.errorUpdating(error: error! as Error as NSError)
                                return
                            }
                        }
                        else
                        {
                            OwnerSingleton.businessLocals.append(BusinessLocal(record: record!, database: self.publicDB))
                            
                            print("Business Local Saved")
                            DispatchQueue.main.async() {
                                self.delegate?.modelUpdated()
                                return
                            }
                        }
                    }
                }
        }
    }
}
    
    func delete(name: String)
    {
        let publicDb = CKContainer.default().publicCloudDatabase
        let predicate = NSPredicate(format: "name == %@", name)
        let query = CKQuery(recordType: "BusinessLocal", predicate: predicate)
        publicDb.perform(query, inZoneWith: nil) { (records, error) in
            if error == nil {
                for record in records! {
                    publicDb.delete(withRecordID: record.recordID, completionHandler: { (recordId, error) in
                        if error == nil {
                            print("businessLocal \(name) deleted")
                        }
                    })
                }
            }
        }
    }
    
}


