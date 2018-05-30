//
//  Advertiser.swift
//  testCloudkit
//
//  Created by giuseppe magnete on 14/02/18.
//  Copyright © 2018 giuseppe magnete. All rights reserved.
//

import UIKit
import CloudKit


class Owner: NSObject {
    var record:  CKRecord
    var database: CKDatabase
    var email: String
    var password: String
    var piva: String
    var premium: String
    var name: String
    var telephone: String
    
    init(record: CKRecord, database: CKDatabase)
    {
        self.record = record
        self.database = database
    
        self.email = record.object(forKey: "email") as! String
        self.password = record.object(forKey: "password") as! String
        self.piva = record.object(forKey: "piva") as! String
        self.premium = record.object(forKey: "premium") as! String
        self.name = record.object(forKey: "name") as! String
        self.telephone = record.object(forKey: "telephone") as! String
    }
    
}
