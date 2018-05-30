//
//  ErrorManager.swift
//  JapanIceTea
//
//  Created by Giuseppe Magnete on 16/02/18.
//  Copyright © 2018 7App, iOSDA. All rights reserved.
//

import UIKit

class ErrorManager {

    static func manage(codeError: Int, message: String, viewController: UIViewController) {

        var alert = UIAlertController()
        
        switch codeError {

            case 1:
                alert = UIAlertController(title: "signup failed", message: message, preferredStyle: .alert)

            case 401:
                alert = UIAlertController(title: "authentication failed", message: message, preferredStyle: .alert)

            default:
                print("generic error")

        }

        alert.addAction(UIAlertAction(title: "ok", style: .default, handler: nil))
        viewController.present(alert, animated: true)

    }

}
