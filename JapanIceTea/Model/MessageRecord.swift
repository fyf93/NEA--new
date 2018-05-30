//
//  MessageRecord.swift
//  testCloudkit
//
//  Created by giuseppe magnete on 20/02/18.
//  Copyright © 2018 giuseppe magnete. All rights reserved.
//

import UIKit
import CloudKit

class MessageRecord {
    var record:  CKRecord
    var database: CKDatabase
    var mittente: String
    var messaggio: String
    var destinatario : String
    var data : Date
    var new : Int
    
    
    
    init(record: CKRecord, database: CKDatabase)
    {
        self.record = record
        self.database = database
        self.mittente = record.object(forKey: "mittente") as! String
        self.messaggio = record.object(forKey: "messaggio") as! String
        self.destinatario = record.object(forKey: "destinatario") as! String
        self.data = record.object(forKey: "data") as! Date
        if let new = record.object(forKey: "new") as? Int {
            self.new = new
        }
        else {
            self.new = 0
        }
        
    }
}
