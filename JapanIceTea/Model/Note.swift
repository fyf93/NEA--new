//
//  Note.swift
//  testCloudkit
//
//  Created by giuseppe magnete on 25/01/18.
//  Copyright © 2018 giuseppe magnete. All rights reserved.
//

import UIKit
import CloudKit

class Note: NSObject {
    var record:  CKRecord
    var database: CKDatabase
    var date: NSDate
    var title: String
    var text: String
    
    init(record: CKRecord, database: CKDatabase)
    {
        self.record = record
        self.database = database
        self.date = record.creationDate! as NSDate
        self.title = record.object(forKey: "title") as! String
        self.text = record.object(forKey: "text") as! String
        
    }

}
