//
//  User.swift
//  JapanIceTea
//
//  Created by Ferdinando Mirra on 15/02/18.
//  Copyright © 2018 7App, iOSDA. All rights reserved.
//

import UIKit

class User: NSObject {

    private var email: String
    private var password: String
    private var sentMessages: [Message] = []
    
    init(email: String, password: String) {
        self.email = email
        self.password = password
    }
    
    func getEmail() -> String {
        return self.email
    }

    func getPassword() -> String {
        return self.password
    }

    func getPassword() -> [Message] {
        return self.sentMessages
    }
    
    func sendMessage(content: String, to: User) {
        let id = "0" /* creare id */
        let calendar = Calendar.current /* convertire in date */
        let message = Message(id: id, timestamp: calendar, sender: self, receiver: to, content: content)
        sentMessages.append(message)
    }

}
