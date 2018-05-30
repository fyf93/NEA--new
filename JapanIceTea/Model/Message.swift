//
//  Message.swift
//  JapanIceTea
//
//  Created by Ferdinando Mirra on 15/02/18.
//  Copyright © 2018 7App, iOSDA. All rights reserved.
//

import UIKit

class Message: NSObject {

    private var id: String
    private var timestamp: Calendar
    private var sender: User
    private var receiver: User
    private var content: String

    init(id: String, timestamp: Calendar, sender: User, receiver: User, content: String) {
        self.id = id
        self.timestamp = timestamp
        self.sender = sender
        self.receiver = receiver
        self.content = content
    }

    func getId() -> String {
        return self.id
    }

    func getTimestamp() -> Calendar {
        return self.timestamp
    }

    func getSender() -> User {
        return self.sender
    }

    func getReceiver() -> User {
        return self.receiver
    }

    func getContent() -> String {
        return self.content
    }

}

