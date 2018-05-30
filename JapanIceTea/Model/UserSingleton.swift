//
//  UserSingleton.swift
//  testCloudkit
//
//  Created by giuseppe magnete on 20/02/18.
//  Copyright © 2018 giuseppe magnete. All rights reserved.
//

import UIKit

class UserSingleton {
    
    var name = String()
    var id = String()
    var device = String()
    //var nearAdvertisement = ()
    var selectedBusinessLocalID = String()
    
    static let shared = UserSingleton()
    
    
    
    private init()
    {
        
    }
    
   
    
}
