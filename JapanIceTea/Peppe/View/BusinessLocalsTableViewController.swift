
import UIKit

class BusinessLocalsTableViewController: UITableViewController {
    var businessLocalModel = BusinessLocalModel.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.hidesBackButton = true
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return OwnerSingleton.businessLocals.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle:   UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            businessLocalModel.delete(name: OwnerSingleton.businessLocals[indexPath.row].name)
            OwnerSingleton.businessLocals.remove(at: indexPath.row)
            tableView.beginUpdates()
            tableView.deleteRows(at: [indexPath], with: .middle)
            tableView.endUpdates()
            
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "businessLocalCell", for: indexPath)
        cell.textLabel?.text = OwnerSingleton.businessLocals[indexPath.row].name
        cell.detailTextLabel?.text = OwnerSingleton.businessLocals[indexPath.row].address
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        OwnerSingleton.idxBusinessLocalSelected = indexPath.row
        self.performSegue(withIdentifier: "homeOwner", sender: self)
    }

}
