//
//  ModelDelegate.swift
//  JapanIceTea
//
//  Created by Giuseppe Magnete on 15/02/18.
//  Copyright © 2018 7App, iOSDA. All rights reserved.
//

import UIKit

/*
 * Definisce i metodi di risposta alle operazioni asincrone.
 * Ogni classe che accede a Cloudkit implementa questo protocollo
 */
protocol ModelDelegate {
    func errorUpdating(error: NSError)
    func modelUpdated()
}
