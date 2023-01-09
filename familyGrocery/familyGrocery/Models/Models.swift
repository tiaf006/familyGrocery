//
//  Models.swift
//  familyGrocery
//
//  Created by TAIF Al-zahrani on 16/06/1444 AH.
//

import Foundation

class User : NSObject, Codable{
    var userID : String?
    var userName : String?
    var userEmail : String?
}

class GroceryItem : NSObject, Codable{
    var itemName : String?
    var isCompleated : Bool?
    var addedByUser : String?
}
