//
//  OwnerSignupViewController.swift
//  JapanIceTea
//
//  Created by Giuseppe Magnete on 15/02/18.
//  Copyright © 2018 7App, iOSDA. All rights reserved.
//

import UIKit

class OwnerSignupViewController: UIViewController, ModelDelegate {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var passwordConfirmTextField: UITextField!
    @IBOutlet weak var pivaTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var surnameTextField: UITextField!
    @IBOutlet weak var telephoneTextField: UITextField!

    var model = OwnerModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.model.delegate = self
        setupTextFields()
    }

    func setupTextFields() {
        
        emailTextField.layer.borderWidth = 1.0
        emailTextField.layer.borderColor = UIColor(red: 44/255, green: 46/255, blue: 55/255, alpha: 1).cgColor
        emailTextField.backgroundColor = UIColor(red: 44/255, green: 46/255, blue: 55/255, alpha: 1)
        emailTextField.attributedPlaceholder = NSAttributedString(string: "Insert your email",
                                                                  attributes: [NSAttributedStringKey.foregroundColor: UIColor.white])
        passwordTextField.layer.borderWidth = 1.0
        passwordTextField.layer.borderColor = UIColor(red: 44/255, green: 46/255, blue: 55/255, alpha: 1).cgColor
        passwordTextField.backgroundColor = UIColor(red: 44/255, green: 46/255, blue: 55/255, alpha: 1)
        passwordTextField.attributedPlaceholder = NSAttributedString(string: "Insert your password",
                                                                     attributes: [NSAttributedStringKey.foregroundColor: UIColor.white])

        passwordConfirmTextField.layer.borderWidth = 1.0
        passwordConfirmTextField.layer.borderColor = UIColor(red: 44/255, green: 46/255, blue: 55/255, alpha: 1).cgColor
        passwordConfirmTextField.backgroundColor = UIColor(red: 44/255, green: 46/255, blue: 55/255, alpha: 1)
        passwordConfirmTextField.attributedPlaceholder = NSAttributedString(string: "Repeat your password",
                                                                     attributes: [NSAttributedStringKey.foregroundColor: UIColor.white])

        pivaTextField.layer.borderWidth = 1.0
        pivaTextField.layer.borderColor = UIColor(red: 44/255, green: 46/255, blue: 55/255, alpha: 1).cgColor
        pivaTextField.backgroundColor = UIColor(red: 44/255, green: 46/255, blue: 55/255, alpha: 1)
        pivaTextField.attributedPlaceholder = NSAttributedString(string: "Insert your partita iva",
                                                                     attributes: [NSAttributedStringKey.foregroundColor: UIColor.white])
        nameTextField.layer.borderWidth = 1.0
        nameTextField.layer.borderColor = UIColor(red: 44/255, green: 46/255, blue: 55/255, alpha: 1).cgColor
        nameTextField.backgroundColor = UIColor(red: 44/255, green: 46/255, blue: 55/255, alpha: 1)
        nameTextField.attributedPlaceholder = NSAttributedString(string: "Insert your name",
                                                                 attributes: [NSAttributedStringKey.foregroundColor: UIColor.white])

        surnameTextField.layer.borderWidth = 1.0
        surnameTextField.layer.borderColor = UIColor(red: 44/255, green: 46/255, blue: 55/255, alpha: 1).cgColor
        surnameTextField.backgroundColor = UIColor(red: 44/255, green: 46/255, blue: 55/255, alpha: 1)
        surnameTextField.attributedPlaceholder = NSAttributedString(string: "Insert your surname",
                                                                 attributes: [NSAttributedStringKey.foregroundColor: UIColor.white])

        telephoneTextField.layer.borderWidth = 1.0
        telephoneTextField.layer.borderColor = UIColor(red: 44/255, green: 46/255, blue: 55/255, alpha: 1).cgColor
        telephoneTextField.backgroundColor = UIColor(red: 44/255, green: 46/255, blue: 55/255, alpha: 1)
        telephoneTextField.attributedPlaceholder = NSAttributedString(string: "Insert your phone",
                                                                    attributes: [NSAttributedStringKey.foregroundColor: UIColor.white])
    }
    
    func errorUpdating(error: NSError) {
        print("error updating")
    }
    
    func modelUpdated() {
        print("save owner in CloudKit")
        self.navigationController?.popToRootViewController(animated: true)
    }

    @IBAction func saveOwner(_ sender: UIBarButtonItem) {

        if ((passwordTextField.text?.isEmpty == false) && (passwordTextField.text == passwordConfirmTextField.text)) {
            
            // andrebbero fatti altri controlli oltre alla coincidenza dei campi password
            self.model.saveOwner(name: nameTextField.text!, telefono: telephoneTextField.text!, email: emailTextField.text!, password: passwordTextField.text!, piva: pivaTextField.text!, premium: "no" )
            
            print("save owner")
        }
    }

}
