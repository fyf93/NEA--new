//
//  MessageModel.swift
//  testCloudkit
//
//  Created by giuseppe magnete on 20/02/18.
//  Copyright © 2018 giuseppe magnete. All rights reserved.
//

import UIKit
import CloudKit

class MessageModel {
    var container: CKContainer
    var publicDB : CKDatabase
    let privateDB : CKDatabase
    var incomingChat = [MessageStruct]()
    var conversation = [MessageStruct]()
    var user = String()
    static let shared = MessageModel()
    var delegate : ModelDelegate?
    
    private init(){
        container = CKContainer.default()
        publicDB = container.publicCloudDatabase
        privateDB = container.privateCloudDatabase
        
    }
    
    func deleteAllMessages()
    {
        let publicDb = CKContainer.default().publicCloudDatabase
        let query = CKQuery(recordType: "Message", predicate: NSPredicate(format: "TRUEPREDICATE", argumentArray: nil))
        publicDb.perform(query, inZoneWith: nil) { (records, error) in
            if error == nil {
                for record in records! {
                    publicDb.delete(withRecordID: record.recordID, completionHandler: { (recordId, error) in
                        if error == nil {
                            print("Record deleted")
                        }
                    })
                }
            }
        }
    }
    
    func markMessageAsRead(ID: String)
    {
        let recordId = CKRecordID(recordName: ID)
        CKContainer.default().publicCloudDatabase.fetch(withRecordID: recordId) { updatedRecord, error in
            if error != nil {
                return
            }
           // updatedRecord?.setObject(0 as CKRecordValue, forKey: "new")
            updatedRecord?.setValue(0, forKey: "new")
            CKContainer.default().publicCloudDatabase.save(updatedRecord!) { savedRecord, error in
                if (error != nil)
                {
                    print("error update Message:\(error)")
                    DispatchQueue.main.async() {
                        self.delegate?.errorUpdating(error: error! as NSError)
                        return
                    }
                }
                else
                {
                    print("Messaggio marked as read:")
                    DispatchQueue.main.async() {
                        self.delegate?.modelUpdated()
                        return
                    }
                }
    
    }
    }
    }
    /*func markMessageAsRead(ID: String)
    {
        var ckr = CKRecordID(recordName: ID)
        self.publicDB.fetch(withRecordID: ckr, completionHandler: <#T##(CKRecord?, Error?) -> Void#>)
            
            
            .fetchRecordWithID(CKRecordID(recordName: recordId), completionHandler: {record, error in
        //let predicato = NSPredicate(format: "recordName)
       // let predicato = NSPredicate(format: "%K == %@", "creatorUserRecordID" ,CKReference(recordID: theSearchRecordId, action: CKReferenceAction.None))
  //      var query = CKQuery(recordType: recordType, predicate: NSPredicate(format: "%K == %@", "creatorUserRecordID" ,CKReference(recordID: theSearchRecordId, action: CKReferenceAction.None)))

        let queryMessage = CKQuery(recordType: "Message", predicate: predicato)
        self.publicDB.perform(queryMessage, inZoneWith: nil) { (results, error) in
            if error != nil
            {
                DispatchQueue.main.async() {
                    self.delegate?.errorUpdating(error: error! as NSError)
                    return
                }
            }
            else
            {
                    let record = results?.first
                record?.setValue(0, forKey: "new")
               
                self.publicDB.save(record!) { (result, error) -> Void in
                    if (error != nil)
                    {
                        print("error update Message:\(error)")
                        DispatchQueue.main.async() {
                            self.delegate?.errorUpdating(error: error! as NSError)
                            return
                        }
                    }
                    else
                    {
                        print("Messaggio marked as read:")
                        DispatchQueue.main.async() {
                            self.delegate?.modelUpdated()
                            return
                        }
                    }
                }
                    //  print("message=\(message.messaggio)")
            }
        }
    }*/
    func loadConversation(clienteID : String, businessLocalID : String)
    {
       /*//uso 2 predicati per caricati l'intera conversazione, sia i messaggi inviati che ricevuti
        let predicate1 = NSPredicate(format: "mittente == %@ and destinatario == %@", clienteID, businessLocalID)
        let predicate2 = NSPredicate(format: "mittente == %@ and destinatario == %@", businessLocalID, clienteID)
       let predicateCompound = NSCompoundPredicate(type: .or, subpredicates: [predicate1,predicate2])*/
        let predicato = NSPredicate(format: "mittente in %@ AND destinatario in %@", [clienteID, businessLocalID], [clienteID, businessLocalID])
        let queryMessage = CKQuery(recordType: "Message", predicate: predicato)
        
        queryMessage.sortDescriptors = [NSSortDescriptor(key: "data", ascending: true)]
        self.publicDB.perform(queryMessage, inZoneWith: nil) { (results, error) in
            if error != nil
            {
                DispatchQueue.main.async() {
                    self.delegate?.errorUpdating(error: error! as NSError)
                    return
                }
            }
            else
            {
                self.conversation.removeAll()
               //print("elenco messaggi")
                for record in results!
                {
                    let message = MessageRecord(record: record as CKRecord, database: self.publicDB)
                    
                    self.conversation.append(MessageStruct(mittente: message.mittente,  destinatario: message.destinatario, messaggio: message.messaggio, data: message.data, new: message.new, ID: record.recordID.recordName))
                  //  print("message=\(message.messaggio)")
                }
            }
            DispatchQueue.main.async() {
                print("async")
                self.delegate?.modelUpdated()
                return
            }
        }
}
    
    
    func loadIncomingChat(businessLocalID : String)
    {
        let predicate = NSPredicate(format: "destinatario == %@", businessLocalID)
        
        let queryMessage = CKQuery(recordType: "Message", predicate: predicate)
        self.publicDB.perform(queryMessage, inZoneWith: nil) { (results, error) in
            
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
               self.incomingChat.removeAll()
                for record in results!
                {
                    let message = MessageRecord(record: record as CKRecord, database: self.publicDB)
                    print("incoming chat:\(message.messaggio)")
                    if (self.incomingChat.count > 0)
                    {
                    for mess in self.incomingChat
                    {
                      //  print("m=\(mess.mittente)")
                      //  print("m2=\(message.mittente)")
                        if (mess.mittente != message.mittente)
                        {
                            //print("mittente già inserito")
                            self.incomingChat.append(MessageStruct(mittente: message.mittente, destinatario: message.destinatario, messaggio: message.messaggio, data: message.data, new: message.new, ID: record.recordID.recordName))
                        }
                    }
                    }
                    else
                    {
                        self.incomingChat.append(MessageStruct(mittente: message.mittente, destinatario: message.destinatario, messaggio: message.messaggio, data: message.data, new: message.new, ID: record.recordID.recordName))
                    }
                }
            }
            DispatchQueue.main.async() {
               
                self.delegate?.modelUpdated()
                return
            }
            
        }
    }
    
    
    func sendMessage(messaggio: String, mittente: String, destinatario : String)
    {
        let data_now = Date()
        let mRecord = CKRecord(recordType: "Message")
        mRecord.setValue(messaggio, forKey: "messaggio")
        mRecord.setValue(mittente, forKey: "mittente")
        mRecord.setValue(destinatario, forKey: "destinatario")
        mRecord.setValue(data_now, forKey: "data")
        mRecord.setValue(1, forKey: "new")
        self.publicDB.save(mRecord) { (record, error) -> Void in
        if (error != nil)
        {
            print("error save Message:\(error)")
            DispatchQueue.main.async() {
                self.delegate?.errorUpdating(error: error! as NSError)
                return
            }
        }
                        else
                        {
                            print("Messaggio salvato: \(mittente)")
                            self.conversation.append(MessageStruct(mittente: mittente,  destinatario: destinatario, messaggio: messaggio, data: data_now, new: 1, ID: (record?.recordID.recordName)!))
                            DispatchQueue.main.async() {
                                self.delegate?.modelUpdated()
                                return
                            }
                        }
                    }
        
        
                    
    }
    
    
}
