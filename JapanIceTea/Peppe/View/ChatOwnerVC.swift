import UIKit
import CloudKit

class Cell: UITableViewCell
{
    
}
class LeftCell: Cell
{
    @IBOutlet weak var dateOldMessage: UILabel!
    @IBOutlet weak var oldMessage: UITextView!
}
class RightCell: Cell
{
    @IBOutlet weak var dateOldMessage: UILabel!
    @IBOutlet weak var oldMessage: UITextView!
}

class ChatOwnerVC: UIViewController, UITableViewDataSource, UITableViewDelegate, ModelDelegate, UITextFieldDelegate{
    
    @IBOutlet weak var botChat1: UIButton!
    @IBOutlet weak var botChat2: UIButton!
    @IBOutlet weak var botChat3: UIButton!
    var user = String()
    var model = MessageModel.shared
    var businessLocalID = OwnerSingleton.businessLocals[OwnerSingleton.idxBusinessLocalSelected].record.recordID.recordName

    @IBOutlet weak var textMessage: UITextField!
    @IBOutlet weak var chatTableView: UITableView!
    
    @IBAction func sendBotMessage1(_ sender: UIButton) {
        textMessage.text = sender.titleLabel?.text
    }
    
    @IBAction func sendBotMessage2(_ sender: UIButton) {
        textMessage.text = sender.titleLabel?.text
    }
    
    @IBAction func sendBotMessage3(_ sender: UIButton) {
        textMessage.text = sender.titleLabel?.text
    }
    
   
    @IBAction func sendMessage(_ sender: Any) {
        if textMessage.text?.isEmpty == false
        {
            model.sendMessage(messaggio: textMessage.text!, mittente: businessLocalID, destinatario: user)
            self.textMessage.text = ""
            self.scrolling(animated: true)
            textMessage.resignFirstResponder()
        }       
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.chatTableView.delegate = self
        self.chatTableView.dataSource = self
        loadConversation()
        self.model.delegate = self
        textMessage.delegate = self
        scrolling(animated: true)
        NotificationCenter.default.addObserver(self, selector: #selector(self.loadConversation), name: NSNotification.Name(rawValue: "loadConversation"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(willEnterForeground), name: .UIApplicationWillEnterForeground, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
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
        print("Carico la conversazione tra il cliente \(self.user) e il locale \(businessLocalID)")
        model.loadConversation(clienteID: self.user, businessLocalID: self.businessLocalID)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
     return self.model.conversation.count
    }
    

    // MARK: - Table view data source
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    func errorUpdating(error: NSError) {
        print("error chat")
    }
    
    func modelUpdated() {
        print("ok chat")
        self.scrolling(animated: true)
        self.chatTableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        return 65
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var conversation = self.model.conversation[indexPath.row]        //in base al mittente stabilisco se devo visualizzare un mesaggio in entrato o in uscita
        if (conversation.mittente == self.businessLocalID)
        {
            //print("left_cell")
            var cell = tableView.dequeueReusableCell(withIdentifier: "left") as! LeftCell
            cell.oldMessage.text = conversation.messaggio
            cell.dateOldMessage.isHidden = true
            cell.dateOldMessage.text = conversation.data.description
            cell.oldMessage.translatesAutoresizingMaskIntoConstraints = false
            return cell
        }
        else
        {
           // print("right_cell")
            var cell = tableView.dequeueReusableCell(withIdentifier: "right") as! RightCell
            cell.oldMessage.text = conversation.messaggio
            //cell.oldMessage.isScrollEnabled = false
            cell.dateOldMessage.text = conversation.data.description
            cell.dateOldMessage.isHidden = true
            cell.oldMessage.translatesAutoresizingMaskIntoConstraints = false
            if conversation.new == 1
            {
                conversation.new = 0
                cell.dateOldMessage.font = UIFont.boldSystemFont(ofSize: 11.0)
                cell.oldMessage.font = UIFont.boldSystemFont(ofSize: 13)
                //UIFont(name: "HelveticaNeue-Bold", size: 17)// for medium
                decrementBadgeCounter()
                self.model.markMessageAsRead(ID: conversation.ID)
            }
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
