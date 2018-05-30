//
//  Advertisement.swift
//  JapanIceTea
//
//  Created by Ferdinando Mirra on 14/02/18.
//  Copyright © 2018 7App, iOSDA. All rights reserved.
//

import UIKit

class Ad: NSObject {

    private var id: String
    private var title: String
    private var localName: String
    private var subtitle: String
    private var details: String
    private var date: Date
    private var address: String
    private var latitude: Double
    private var longitude: Double
    private var photo: UIImage
    public var businessLocalID: String
    
    init(id: String, title: String, subtitle: String, details: String, date: Date, address: String, latitude: Double, longitude: Double, photo: UIImage, businessLocalID: String, localName: String
        ) {
        self.id = id
        self.title = title
        self.subtitle = subtitle
        self.details = details
        self.date = date
        self.address = address
        self.latitude = latitude
        self.longitude = longitude
        self.photo = photo
        self.businessLocalID = businessLocalID
        self.localName = localName
    }

    func getId() -> String {        
        return self.id
    }

    func getTitle() -> String {
        return self.title
    }
    func getLocalName() -> String {
        return self.localName
    }

    func getSubtitle() -> String {
        return self.subtitle
    }

    func getAddress() -> String {
        return self.address
    }

    func getDetails() -> String {
        return self.details
    }

    func getDate() -> Date {
        return self.date
    }

    func getLatitude() -> Double {
        return self.latitude
    }

    func getLongitude() -> Double {
        return self.longitude
    }

    func getPhoto() -> UIImage {
        return self.photo
    }

}
