
import UIKit

class OwnerLoginViewController: UIViewController, ModelDelegate {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!

    @IBOutlet var label1: UILabel!
    
    
    var model = OwnerModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.model.delegate = self
        setupTextFields()
    }

    func setupTextFields() {

//        emailTextField.layer.borderWidth = 1.0
//        emailTextField.layer.borderColor = UIColor(red: 44/255, green: 46/255, blue: 55/255, alpha: 1).cgColor
//        emailTextField.backgroundColor = UIColor(red: 44/255, green: 46/255, blue: 55/255, alpha: 1)
        emailTextField.attributedPlaceholder = NSAttributedString(string: "Insert your email",
                                                                  attributes: [NSAttributedStringKey.foregroundColor: UIColor.white])
//        passwordTextField.layer.borderWidth = 1.0
//        passwordTextField.layer.borderColor = UIColor(red: 44/255, green: 46/255, blue: 55/255, alpha: 1).cgColor
//        passwordTextField.backgroundColor = UIColor(red: 44/255, green: 46/255, blue: 55/255, alpha: 1)
        passwordTextField.attributedPlaceholder = NSAttributedString(string: "Insert your password",
                                                                     attributes: [NSAttributedStringKey.foregroundColor: UIColor.white])
    }
   
    
    
    @IBAction func RecoveryPass(_ sender: Any) {
        label1.isHidden = false
    }
    
    @IBAction func login(_ sender: UIButton) {
        loadingBar()
    
        self.model.loginAdvertiser(email: emailTextField.text!, password: passwordTextField.text!)
    }

    func errorUpdating(error: NSError) {
        dismiss(animated: true, completion: nil)
        ErrorManager.manage(codeError: error.code, message: error.domain, viewController: self)
    }
    
    func modelUpdated() {
        dismiss(animated: false, completion: nil)
        if (self.model.risultato == true) {
            let countBusinessLocal = OwnerSingleton.businessLocals.count
            print("end login, num Locali:\(countBusinessLocal)")
            if (countBusinessLocal > -1) {
                performSegue(withIdentifier: "businessLocals", sender: self)
            } else {
                performSegue(withIdentifier: "loginOK", sender: self)
            }
 
            //performSegue(withIdentifier: "businessLocals", sender: self)
        } else {
            print("riprova")
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
            case "loginOK"?:
                let vc_advertising = segue.destination as! OwnerHomeViewController
                vc_advertising.navigationItem.hidesBackButton = true
            case "businessLocals"?:
                print("scelta")
                let scelta = segue.destination as! BusinessLocalsTableViewController
                scelta.navigationItem.hidesBackButton = true
            default:
                print("identifier non trovato")
        }
    }

}
