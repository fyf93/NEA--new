//
//  ChatUserVC.swift
//  testCloudkit
//
//  Created by giuseppe magnete on 21/02/18.
//  Copyright © 2018 giuseppe magnete. All rights reserved.
//

import UIKit
import CloudKit

class CellUser: UITableViewCell
{
    
}
class LeftCellUser: CellUser
{
   
    @IBOutlet weak var data: UILabel!
    @IBOutlet weak var message: UITextView!
}

class RightCellUser: CellUser
{
    @IBOutlet weak var message: UITextView!
    @IBOutlet weak var data: UILabel!
}

class ChatUserVC: UIViewController, UITableViewDataSource, UITableViewDelegate, ModelDelegate, UITextFieldDelegate {
    
    var model = MessageModel.shared
    
    //var businessLocalID = "B9BF4C21-D02A-404C-8210-6230C2B99BC1"
   
    
    //var businessLocalID = UserSingleton.shared.selectedBusinessLocalID
    var user = UserSingleton.shared.name+"_"+UserSingleton.shared.id
    
    @IBOutlet weak var textMessage: UITextField!
    @IBOutlet weak var chatTableView: UITableView!
    
    
    @IBAction func sendMessage(_ sender: Any) {
        
        if textMessage.text?.isEmpty == false
        {
            print("invio messaggio a \(UserSingleton.shared.selectedBusinessLocalID)")
            model.sendMessage(messaggio: textMessage.text!, mittente: self.user, destinatario: UserSingleton.shared.selectedBusinessLocalID)
            self.textMessage.text = ""
            self.scrolling(animated: true)
            textMessage.resignFirstResponder()
            self.chatTableView.reloadData()
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.chatTableView.delegate = self
        self.chatTableView.dataSource = self
        self.model.delegate = self
        loadConversation()
        print("pagina chat con locale \(UserSingleton.shared.selectedBusinessLocalID)")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.chatTableView.delegate = self
        self.chatTableView.dataSource = self
        loadConversation()
        self.model.delegate = self
        
        textMessage.delegate = self
        NotificationCenter.default.addObserver(self, selector: #selector(self.loadConversation), name: NSNotification.Name(rawValue: "loadConversation"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(willEnterForeground), name: .UIApplicationWillEnterForeground, object: nil)

        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
       //resetBadgeCounter()
        scrolling(animated: true)
         print("pagina chat con locale \(UserSingleton.shared.selectedBusinessLocalID)")
    }
    
    @objc func willEnterForeground() {
        print("willenterforeground")
        loadConversation()
        self.scrolling(animated: true)
        self.chatTableView.reloadData()
      //  decrementBadgeCounter()
    }
    
    func decrementBadgeCounter() {
        let count = UIApplication.shared.applicationIconBadgeNumber - 1
        let badgeResetOperation = CKModifyBadgeOperation(badgeValue: count )
        badgeResetOperation.modifyBadgeCompletionBlock = { (error) -> Void in
            if error != nil {
                print("Error decrement badge: \(error)")
            }
            else {
                DispatchQueue.main.async {
                    UIApplication.shared.applicationIconBadgeNumber = count
                }
            }
        }
        print("decrement \(count)")
        CKContainer.default().add(badgeResetOperation)
    }
    
   /* func resetBadgeCounter() {
        let badgeResetOperation = CKModifyBadgeOperation(badgeValue: 0)
        badgeResetOperation.modifyBadgeCompletionBlock = { (error) -> Void in
            if error != nil {
                print("Error resetting badge: \(error)")
            }
            else {
                DispatchQueue.main.async {
                    UIApplication.shared.applicationIconBadgeNumber = 0
                }
            }
        }
        CKContainer.default().add(badgeResetOperation)
    }
    */
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0{
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }
    @objc func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y != 0{
                self.view.frame.origin.y += keyboardSize.height
            }
        }
    }
    
    //nasconde la tastiera dopo aver premuto invio
    func textFieldShouldReturn(_ text: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }

    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver("loadConversation")
    }
    
    @objc func loadConversation()
    {
      //  print("Carico conversazione tra cliente \(self.user) e il locale \(businessLocalID)")
        model.loadConversation(clienteID: self.user, businessLocalID: UserSingleton.shared.selectedBusinessLocalID)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

   func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.model.conversation.count
    }
    func errorUpdating(error: NSError) {
        print("error userchat")
    }
    
    func modelUpdated() {
        print("update chat")
        //self.scrolling(animated: true)
        self.chatTableView.reloadData()
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 65
    }
//    func setupTextField(textField: UITextField)
//    {
//        textField.layer.masksToBounds 
//    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var conversation = self.model.conversation[indexPath.row]
        //in base al mittente stabilisco se devo visualizzare un mesaggio in entrato o in uscita
        if (conversation.mittente == UserSingleton.shared.selectedBusinessLocalID)
        {
            //print("left_cell")
            var cell = tableView.dequeueReusableCell(withIdentifier: "leftUser") as! LeftCellUser
            cell.message.text = conversation.messaggio
            cell.data.text = conversation.data.description
            
            if conversation.new == 1
            {
                self.model.conversation[indexPath.row].new = 0
                cell.data.font = UIFont.boldSystemFont(ofSize: 11.0)
                cell.message.font = UIFont.boldSystemFont(ofSize: 13)
                //UIFont(name: "HelveticaNeue-Bold", size: 17)// for medium
                decrementBadgeCounter()
                self.model.markMessageAsRead(ID: conversation.ID)
            }
            cell.message.translatesAutoresizingMaskIntoConstraints = false
            return cell
        }
        else
        {
            // print("right_cell")
            var cell = tableView.dequeueReusableCell(withIdentifier: "rightUser") as! RightCellUser
            cell.message.text = conversation.messaggio
            //cell.oldMessage.isScrollEnabled = false
            cell.message.translatesAutoresizingMaskIntoConstraints = false
            cell.data.text = conversation.data.description
            return cell
        }
    }
    
func scrolling(animated: Bool) {

    DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(400)) {
        let numberOfSections = self.chatTableView.numberOfSections
        let numberOfRows = self.chatTableView.numberOfRows(inSection: numberOfSections-1)
        if numberOfRows > 0 {
            let indexPath = IndexPath(row: numberOfRows-1, section: (numberOfSections-1))
            self.chatTableView.scrollToRow(at: indexPath, at: .bottom, animated: animated)
             self.chatTableView.reloadData()
        }
    }
}
}
