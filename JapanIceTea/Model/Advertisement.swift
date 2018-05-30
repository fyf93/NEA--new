//
//  Advertisement.swift
//  testCloudkit
//
//  Created by giuseppe magnete on 19/02/18.
//  Copyright © 2018 giuseppe magnete. All rights reserved.
//

import UIKit
import CloudKit


class Advertisement {
    var record:  CKRecord
    var database: CKDatabase
    var name: String
    var descr: String
    var dateTime : Date
    var day: String
    var time: String
    var oneTimeEvent : Int
    var owner: CKReference
    var businessLocal: CKReference
    var range: Int
    var geofenceType: String
    var location: CLLocation
    
   
    
    init(record: CKRecord, database: CKDatabase)
    {
        self.record = record
        self.database = database
        self.name = record.object(forKey: "name") as! String
        self.descr = record.object(forKey: "description") as! String
        self.dateTime = record.object(forKey: "dateTime") as! Date
        self.day = record.object(forKey: "day") as! String
        self.time = record.object(forKey: "time") as! String
        self.businessLocal = record.object(forKey: "businessLocal") as! CKReference
        self.owner = record.object(forKey: "owner") as! CKReference
        self.oneTimeEvent = record.object(forKey: "oneTimeEvent") as! Int
        self.range = record.object(forKey: "range") as! Int
        self.geofenceType = record.object(forKey: "geofenceType") as! String
        self.location = record.object(forKey: "location") as! CLLocation
    }
}
