//
//  Contact.swift
//  solsticeContacts
//
//  Created by Patrick Wilson on 2/12/16.
//  Copyright © 2016 Patrick Wilson. All rights reserved.
//

import UIKit

class Contact: NSObject {
    var birthdate : String
    var company : String
    var detailsURL : String
    var employeeID : NSNumber
    var name : String
    var phone : NSMutableDictionary
    var smallImageURL : String
    
    init(birthdate : String , company : String,detailsURL : String,employeeID : NSNumber,name : String,phone : NSMutableDictionary,smallImageURL : String) {
        self.birthdate = birthdate
        self.company = company
        self.detailsURL = detailsURL
        self.employeeID = employeeID
        self.name = name
        self.phone = phone
        self.smallImageURL = smallImageURL
    }
}
