//
//  BusinessLocal.swift
//  testCloudkit
//
//  Created by giuseppe magnete on 12/02/18.
//  Copyright © 2018 giuseppe magnete. All rights reserved.
//

import UIKit
import CloudKit
//classe che definisce la struttura del recod BusinessLocal (identica a cloudkit). collegamento tra cloudkit e codice swift
class BusinessLocal: NSObject {
    var record:  CKRecord
    var database: CKDatabase
    var address: String
    var approved: String
    var descr : String
    //var email : String
    var location : CLLocation
    var mainPhoto : CKAsset
    var name : String
    //var password : String
   // var piva : String
    var type : String
    var owner : CKReference
    
    init(record: CKRecord, database: CKDatabase)
    {
        self.record = record
        self.database = database
       // self.date = record.creationDate! as NSDate
        self.address = record.object(forKey: "address") as! String
        self.descr = record.object(forKey: "description") as! String
        //self.email = record.object(forKey: "email") as! String
        self.approved = record.object(forKey: "approved") as! String
        self.location = record.object(forKey: "location") as! CLLocation
        self.mainPhoto = record.object(forKey: "mainPhoto") as! CKAsset
        self.owner = record.object(forKey: "owner") as! CKReference
        self.name = record.object(forKey: "name") as! String
       // self.password = record.object(forKey: "password") as! String
       /* if let piva = record.object(forKey: "piva") as? String {
            self.piva = piva
        }
        else
        {
            self.piva = ""
        }*/
        self.type = record.object(forKey: "type") as! String
        
    }

}
