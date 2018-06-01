//
//  IncomingChat.swift
//  testCloudkit
//
//  Created by giuseppe magnete on 20/02/18.
//  Copyright © 2018 giuseppe magnete. All rights reserved.
//

import UIKit
import CloudKit

class IncomingChatTVC: UITableViewController, ModelDelegate {
    func errorUpdating(error: NSError) {
        print("error incomingChat")
    }
    
    func modelUpdated() {
        print("RELOAD incoming chat")
       
        self.tableView.reloadData()
    }
    
    var model = MessageModel.shared
    var elencoUtenti = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.model.delegate = self
        
        loadIncomingChat()
        
        //Uncomment the following line to preserve selection between presentations
        //self.clearsSelectionOnViewWillAppear = false
    }
    
    func loadIncomingChat()
    {
        let businessLocalID = OwnerSingleton.businessLocals[OwnerSingleton.idxBusinessLocalSelected].record.recordID.recordName
        model.loadIncomingChat(businessLocalID: businessLocalID)
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return model.incomingChat.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        model.user = model.incomingChat[indexPath.row].mittente
      
        self.performSegue(withIdentifier: "chat", sender: self)
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "user", for: indexPath)
        cell.textLabel?.text = model.incomingChat[indexPath.row].mittente
        cell.detailTextLabel?.text = model.incomingChat[indexPath.row].messaggio
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "chat" {
            let chat = segue.destination as! ChatOwnerVC
            print("apro pagina chat con cliente=\(model.user)")
           chat.user = model.user
        }
        
    }
}
