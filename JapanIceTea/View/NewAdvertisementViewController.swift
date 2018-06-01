//
//  NewAdvertisementViewController.swift
//  JapanIceTea
//
//  Created by Giuseppe Magnete on 16/02/18.
//  Copyright © 2018 7App, iOSDA. All rights reserved.
//

import UIKit
import CloudKit

class NewAdvertisementViewController:  UIViewController, ModelDelegate, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate, UITextViewDelegate {
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var descriptionTextView: UITextView!
    
    @IBOutlet weak var outletSegment: UISegmentedControl!
    @IBOutlet weak var repeatedAdLabel: UILabel!
    @IBOutlet weak var singleAdvertisementLabel: UILabel!
    @IBOutlet weak var datePickerView: UIDatePicker!
    @IBOutlet weak var dayPickerView: UIPickerView!
    @IBOutlet weak var hourPickerView: UIPickerView!
    
    var model = AdvertisementModel.shared
    var days = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"]
    var hours = ["10:00", "19:00", "19:30", "20:00", "20:30", "21:00", "24:00"]
    var selectedDay: String = "-1"
    var selectedHour : String = "-1"

    
    @IBAction func changeIndex(_ sender: Any) {
        switch outletSegment.selectedSegmentIndex
        {
        case 0:
            self.dayPickerView.reloadInputViews()
            self.hourPickerView.reloadInputViews()
            self.dayPickerView.isHidden = true
            self.hourPickerView.isHidden = true
            self.repeatedAdLabel.isHidden = true
            self.singleAdvertisementLabel.isHidden = false
            self.datePickerView.isHidden = false
            
        case 1:
            self.datePickerView.reloadInputViews()
            self.dayPickerView.isHidden = false
            self.hourPickerView.isHidden = false
            self.repeatedAdLabel.isHidden = false
            self.singleAdvertisementLabel.isHidden = true
            self.datePickerView.isHidden = true
            
        default:
            break
        }    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.model.delegate = self
        self.dayPickerView.delegate = self
        self.dayPickerView.dataSource = self
        self.hourPickerView.delegate = self
        self.hourPickerView.dataSource = self
        self.hourPickerView.setValue(UIColor.white, forKeyPath: "textColor")
        self.dayPickerView.setValue(UIColor.white, forKeyPath: "textColor")
//GM
        self.nameTextField.delegate = self
        self.descriptionTextView.delegate = self
        /*let loc = Locale(identifier: "it")
        self.datePickerView.locale = loc*/
        self.datePickerView.minuteInterval = 30
       // self.datePickerView.setDate(Date(), animated: true)
        self.datePickerView.setValue(UIColor.white, forKeyPath: "textColor")
      //  self.datePickerView.setValue(0.8, forKeyPath: "alpha")
       // self.datePickerView.minimumDate = Date()
        //GM
        self.descriptionTextView.isEditable = true
        self.descriptionTextView.layer.borderWidth = 1
        self.hideKeyboardWhenTappedAround()
        self.dayPickerView.isHidden = true
        self.hourPickerView.isHidden = true
        self.repeatedAdLabel.isHidden = true
        if (OwnerSingleton.idxAdvertisementSelected > -1) {
            let idx = OwnerSingleton.idxAdvertisementSelected
            let ad = OwnerSingleton.advertisements[idx]
            self.nameTextField.text = ad.name
            self.descriptionTextView.text = ad.descr
            // self.dayPicker.setValue("prova", forKey: 0)
        }
    }
    

    @IBAction func saveAdvertisement(_ sender: UIBarButtonItem) {
        loadingBar()
        var oneTimeEvent = 0
        
        if (selectedDay != "-1") {
            oneTimeEvent = 1
        }

        if (nameTextField.text?.isEmpty == false) && (OwnerSingleton.idxBusinessLocalSelected >= 0) {

            let c = OwnerSingleton.businessLocals[OwnerSingleton.idxBusinessLocalSelected].record.recordID
            let referenceBusinessLocal = CKReference(recordID: c, action: CKReferenceAction.deleteSelf)

            // CKReference(record: <#T##CKRecord#>, action: <#T##CKReferenceAction#>)
            // print("ownerID=\(OwnerSingleton.refOwner?.recordID)")
            // print("businessLocal=\(referenceBusinessLocal.recordID)")

            model.saveAdvertisement(name: nameTextField.text!, descr: descriptionTextView.text, dateTime: datePickerView.date, day: self.selectedDay, time: self.selectedHour, oneTimeEvent: oneTimeEvent, owner: OwnerSingleton.refOwner!, businessLocal: referenceBusinessLocal, location: OwnerSingleton.businessLocals[OwnerSingleton.idxBusinessLocalSelected].location)
        }
        
    }
    
    
    func errorUpdating(error: NSError) {
        print("errorUpdating NewAdvertisementViewController")
        dismiss(animated: true, completion: nil)
    }
    
    func modelUpdated() {
        dismiss(animated: true, completion: nil)
        print("modelUpdate NewAdvertisementViewController")
        let switchViewController = self.storyboard?.instantiateViewController(withIdentifier: "OwnerHome") as! OwnerHomeViewController
        
        self.navigationController?.pushViewController(switchViewController, animated: true)
    }

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {

        if (pickerView == dayPickerView) {
            return days.count
        }
        else if (pickerView == hourPickerView) {
            return hours.count
        }

        return 1
    }

    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        if (pickerView == dayPickerView) {
            return NSAttributedString(string: self.days[row], attributes: [NSAttributedStringKey.foregroundColor : UIColor.white])
        } else if (pickerView == hourPickerView) {
            return NSAttributedString(string: self.hours[row], attributes: [NSAttributedStringKey.foregroundColor : UIColor.white])
        }
        
        return NSAttributedString(string: "")
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {

        if (pickerView == dayPickerView) {
            print(self.days[row])
            self.selectedDay = self.days[row]
        } else if (pickerView == hourPickerView) {
            print(self.hours[row])
            self.selectedHour = self.hours[row]
        }
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
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
// Put this piece of code anywhere you like
extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
