//
//  LoginModel.swift
//  testCloudkit
//
//  Created by giuseppe magnete on 14/02/18.
//  Copyright © 2018 giuseppe magnete. All rights reserved.
//

import UIKit
import CloudKit

class OwnerModel {
    var container: CKContainer
    var publicDB : CKDatabase

    
    var advertisers = [Owner]()
    var risultato = false
    var delegate : ModelDelegate?
    
    init(){
        container = CKContainer.default()
        publicDB = container.publicCloudDatabase
        
        //delegate = Login()
    }

    func saveOwner(name: String, telefono: String, email : String, password : String, piva: String, premium: String)
    {
        let predicate = NSPredicate(format: "email == %@", email)
        let query = CKQuery(recordType: "Owner", predicate: predicate)
        
        publicDB.perform(query, inZoneWith: nil) { (results, error) in
            if error != nil
            {
                print("error check email: \(error)")
                DispatchQueue.main.async() {
                    self.delegate?.errorUpdating(error: error! as NSError)
                    return
                }
            }
            else
            {
                if (results?.isEmpty == false)
                {
                    var er = NSError(domain: "Email già registrata", code: 111, userInfo: nil)
                    print(er)
                    DispatchQueue.main.async() {
                        self.delegate?.errorUpdating(error: er as NSError)
                        return
                    }
                }
                else
                {
                     print("Check email ok!")
                    /*+++++++++++++*/
                    let blRecord = CKRecord(recordType: "Owner")
                    blRecord.setValue(name, forKey: "name")
                    blRecord.setValue(telefono, forKey: "telephone")
                    blRecord.setValue(email, forKey: "email")
                    blRecord.setValue(password, forKey: "password")
                    blRecord.setValue(piva, forKey: "piva")
                    blRecord.setValue(premium, forKey: "premium")
                    
                    self.publicDB.save(blRecord) { (record, error) -> Void in
                        if (error != nil)
                        {
                            print("error save Owner:\(error)")
                            DispatchQueue.main.async() {
                                self.delegate?.errorUpdating(error: error! as NSError)
                                return
                            }            }
                        else
                        {
                            print("Owner Saved")
                            DispatchQueue.main.async() {
                                self.delegate?.modelUpdated()
                                return
                            }
                        }
                    }
                    
                }
            }
           
            
        }
        
        /////*********/
    }
    
    
    func loginAdvertiser(email: String, password: String)
    {
       // print("func login \(email)")       
        let predicate = NSPredicate(format: "email == %@ AND password == %@", email, password)
        let query = CKQuery(recordType: "Owner", predicate: predicate)
        
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
                self.advertisers.removeAll(keepingCapacity: true)
                if (results?.isEmpty )!
                {
                   print("Login Fallito")
                    let er = NSError(domain: "Username/password errati", code: 401, userInfo: nil)
                    DispatchQueue.main.async() {
                        self.delegate?.errorUpdating(error: er as NSError)
                        return
                    }
                }
                else
                {
                    for record in results!
                    {
                        let advertiser = Owner(record: record as CKRecord, database: self.publicDB)
                       // if (advertiser.password == password)
                       // {
                          //let ref = record.object(forKey: "Owner") as! CKReference
                            let ref2 = CKReference(record: record, action: .deleteSelf)
                            OwnerSingleton.refOwner = ref2
                            OwnerSingleton.ID = ref2.recordID.recordName
                            OwnerSingleton.email = advertiser.email
                            OwnerSingleton.password = advertiser.password
                            OwnerSingleton.piva = advertiser.piva
                            OwnerSingleton.premium = advertiser.premium
                            print("Login effettuato: \(advertiser.email)")
                            self.risultato = true
                            self.advertisers.append(advertiser)
                            //cerco la lista dei locali associati al proprietario che ha effettuato l'accesso
                            let recordToMatch = CKReference(record: record, action: CKReferenceAction.deleteSelf)
                            
                            let predicate = NSPredicate(format: "owner == %@", recordToMatch)
                            let queryBusinessLocal = CKQuery(recordType: "BusinessLocal", predicate: predicate)
                           // print ("query elenco locali")
                            self.publicDB.perform(queryBusinessLocal, inZoneWith: nil) { (results, error) in
                                if error != nil
                                {
                                    DispatchQueue.main.async() {
                                        self.delegate?.errorUpdating(error: error! as NSError)
                                        return
                                    }
                                }
                                else
                                {
                                    if (results?.isEmpty == false)
                                    {
                                        
                                        OwnerSingleton.businessLocals.removeAll()
                                        for recordBusiness in results!
                                        {
                                            let ckrecord = recordBusiness as CKRecord
                                            let businessLocal = BusinessLocal(record: ckrecord, database: self.publicDB)
                                            print("carico il locale \(businessLocal.name) dal db")
                                            
                                            OwnerSingleton.businessLocals.append(businessLocal)
                                let refBL = CKReference(record: recordBusiness, action: CKReferenceAction.deleteSelf)
                                            
                                           // OwnerSingleton.refBusinessLocals.append(refBL)
                                            //imposto di default la prima attività commerciale
                                            OwnerSingleton.idxBusinessLocalSelected = 0
                                        }
                                        
                                    }
                                }
                                DispatchQueue.main.sync() {
                                    self.delegate?.modelUpdated()
                                    return
                                }
                            }
                            break
                       // }
                    }
                }
            }
           
            
        }
       
    }
}
