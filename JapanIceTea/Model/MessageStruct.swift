//
//  MessageStruct.swift
//  testCloudkit
//
//  Created by giuseppe magnete on 20/02/18.
//  Copyright © 2018 giuseppe magnete. All rights reserved.
//

import UIKit

class MessageStruct {
    var mittente : String
    var messaggio : String
    var destinatario : String
    var data : Date
    var new : Int
    var ID : String
    
    init(mittente : String, destinatario : String, messaggio : String, data: Date, new: Int, ID: String)
    {
        self.mittente = mittente
        self.destinatario = destinatario
        self.messaggio = messaggio
        self.data = data
        self.new = new
        self.ID = ID
        
    }

}
