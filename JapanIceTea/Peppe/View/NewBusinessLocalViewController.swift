//
//  NewBusinessLocalViewController.swift
//  JapanIceTea
//
//  Created by Giuseppe Magnete on 15/02/18.
//  Copyright © 2018 7App, iOSDA. All rights reserved.
//

import UIKit
//import LocationPicker
import CoreLocation
import CloudKit
import MapKit
import Photos

class NewBusinessLocalViewController: UIViewController, ModelDelegate, UIPickerViewDelegate, UIImagePickerControllerDelegate, UIPickerViewDataSource, UINavigationControllerDelegate, UITextFieldDelegate, UITextViewDelegate {

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var typePickerView: UIPickerView!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var photoImageView: UIImageView!

    var model = BusinessLocalModel.shared
    let messageVoid = "No location selected"
    var pickerOption: [String] = [String]()
    let imagePicker = UIImagePickerController()
    var typeSelected = String()
    var address = String()
    var coordinate = CLLocation()

    // variabile valorizzata con indirizzo e lacation della posizione scelta sulla mappa
    var location: Location? {
        didSet {
            let v = location.flatMap({"\($0.title?.prefix(15) ?? "") -  (\($0.coordinate.latitude.description.prefix(7)), \($0.coordinate.longitude.description.prefix(7)))"}) ?? messageVoid
            // locationLabel.text = location.flatMap({ $0.coordinate.latitude.description  }) ?? "No location selected"
            locationLabel.text = v
            self.address = (location?.address)!
            print("address:\(self.address)")
            self.coordinate = (location?.location)!
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
     
        descriptionTextView.isEditable = true
        descriptionTextView.layer.borderWidth = 1
        // descriptionText.layer.borderColor = .black

        checkPermission()
        self.nameTextField.delegate = self
        self.descriptionTextView.delegate = self
        self.model.delegate = self
        self.typePickerView.delegate = self
        self.typePickerView.dataSource = self
        self.imagePicker.delegate = self
        self.photoImageView.isHidden = false
        self.photoImageView.layer.borderWidth = 1
        self.pickerOption = ["Bar", "Disco", "Restaurant"]
        self.typePickerView.setValue(UIColor.white, forKeyPath: "textColor")
    }
    
    override func viewWillAppear(_ animated: Bool) {
  
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
            return false
        }
        return true
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
   
    @IBAction func addPhoto(_ sender: UIButton) {
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
        // imagePicker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
        present(imagePicker, animated: true, completion: nil)
    }
    

    @IBAction func saveBusinessLocal(_ sender: UIBarButtonItem) {
       
        if self.photoImageView == nil
        {
            print("fake image")
            self.photoImageView.image = createFakePhoto()
        }
       
        
        if ((nameTextField.text?.isEmpty == false) && (locationLabel.text != messageVoid) && (typeSelected.isEmpty == false) && OwnerSingleton.refOwner != nil) {
             loadingBar()
            self.model.saveBusinessLocal(name: nameTextField.text!, address: self.address, descr: descriptionTextView.text, location: coordinate, type: typeSelected, approved: "no", mainPhoto: self.photoImageView.image!, owner: OwnerSingleton.refOwner!)
            print("save business local")
        } else {
            print("completa tutti i campi obbligatori")
            showAlert(withTitle: "Dati Incompleti", message: "Compila i dati obbligatori")
        }
    }

    func errorUpdating(error: NSError) {
        print("error save new business local: \(error)")
        dismiss(animated: true, completion: nil)
        ErrorManager.manage(codeError: error.code, message: error.domain, viewController: self)
    }
    
    func modelUpdated() {
        print("save new business local completed")
        
        let switchViewController = self.storyboard?.instantiateViewController(withIdentifier: "tableBusinessLocals") as! BusinessLocalsTableViewController
        dismiss(animated: true, completion: nil)
        self.navigationController?.pushViewController(switchViewController, animated: true)
    }

    func checkPermission() {

        let photoAuthorizationStatus = PHPhotoLibrary.authorizationStatus()

        switch photoAuthorizationStatus {

            case .authorized:
                print("Access is granted by user")

            case .notDetermined:
                PHPhotoLibrary.requestAuthorization({ (newStatus) in

                    print("status is \(newStatus)")
                    
                    if newStatus ==  PHAuthorizationStatus.authorized {
                        print("success")
                    }
                })
                print("errore permessi")

            case .restricted:
                print("User do not have access to photo album.")

            case .denied:
                print("User has denied the permission.")
        }
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {

        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            self.photoImageView.image = pickedImage
        }
        dismiss(animated: true, completion: nil)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.pickerOption.count
    }

    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        return NSAttributedString(string: self.pickerOption[row], attributes: [NSAttributedStringKey.foregroundColor : UIColor.white])
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        print(self.pickerOption[row])
        self.typeSelected = self.pickerOption[row]
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        if segue.identifier == "locationPicker" {
            let locationPicker = segue.destination as! LocationPickerViewController
            locationPicker.location = location
            locationPicker.showCurrentLocationButton = true
            locationPicker.useCurrentLocationAsHint = true
            locationPicker.showCurrentLocationInitially = true
            locationPicker.completion = { self.location = $0 }
        }
    }

}
