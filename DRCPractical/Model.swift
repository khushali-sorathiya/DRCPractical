//
//  Model.swift
//  DRCPractical
//
//  Created by Khushali on 01/07/23.
//

import Foundation


class userdata {
    
    var id : Int
    var name : String
    var email :String
    var contact :String
    var password : String
    
    init(id: Int, name: String, email: String, contact: String, password: String) {
        self.id = id
        self.name = name
        self.email = email
        self.contact = contact
        self.password = password
    }
}

class productdata {
    var id : Int
    var title : String
    var desc :String
    var image :String
    var price : Double
    var category : String
    var rating : Double
    var cartcount : Int
    var isFav : Bool
    
    init(dict:[String:Any]) {
        self.id = dict["id"] as? Int ?? 0
        self.title = dict["title"] as? String ?? ""
        self.desc = dict["description"] as? String ?? ""
        self.image = dict["image"] as? String ?? ""
        self.price = dict["price"] as? Double ?? 0.0
        self.category = dict["category"] as? String ?? ""
        self.cartcount = dict["count"] as? Int ?? 0
        self.isFav = dict["isFav"] as? Bool ?? false
        self.rating = 0
        if let rate = dict["rating"] as? [String:Any] {
            if  let rateing = rate["rate"] as? Double {
                self.rating = rateing
            }
        }
    }
}
