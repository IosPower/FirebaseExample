//
//  UserDetailsModel.swift
//  PiyushSinrojaPractical
//
//  Created by Admin on 18/02/21.
//

import SwiftyJSON

class UserDetailsModel: NSObject {
    
    // MARK: - Variables
    
    var email = ""
    var firstName = ""
    var lastName = ""
    var descri = ""
    var profileColor = ""
    var recordKey = ""
    
    convenience init(json: JSON?) {
        self.init()
        guard let jsonResponse = json else {
            return
        }
        
        email = jsonResponse["email"].stringValue
        firstName = jsonResponse["firstName"].stringValue
        lastName = jsonResponse["lastName"].stringValue
        descri = jsonResponse["description"].stringValue
        profileColor = jsonResponse["profileColor"].stringValue
        recordKey = jsonResponse["recordKey"].stringValue
    }
    
    // MARK: - Get Paramater Data
    
    func getUserDetails() -> [String: String] {
        let dic = ["email": email,
                   "firstName": firstName,
                   "lastName": lastName,
                   "description": descri,
                   "profileColor": profileColor,
                   "recordKey": recordKey]
        return dic
    }
}
