//
//  ContactDetail.swift
//  solsticeContacts
//
//  Created by Patrick Wilson on 2/13/16.
//  Copyright © 2016 Patrick Wilson. All rights reserved.
//

import UIKit

class ContactDetail: NSObject {
    var employeeID : NSNumber
    var favorite : Bool
    var largeImageURL : String
    var email : String
    var website : String
    var address : NSMutableDictionary
    
    override init() {
        self.employeeID = 0
        self.favorite = false
        self.largeImageURL = ""
        self.email = ""
        self.website = ""
        self.address = [
            "street" : "",
            "city" : "",
            "state" : "",
            "zip" : ""
        ]
    }
    
    init( employeeID : NSNumber, favorite : Bool, largeImageURL : String, email : String, website : String, address : NSMutableDictionary) {
        self.employeeID = employeeID
        self.favorite = favorite
        self.largeImageURL = largeImageURL
        self.email = email
        self.website = website
        self.address = address
    }
}


