//
//  Messages.swift
//  PiyushSinrojaPractical
//
//  Created by Admin on 18/02/21.
//

import UIKit

class Messages: NSObject {

    struct Common {
        ///
        static let strReqTimeOut = "The request timed out, please try again."
        ///
        static let internetAlertMsg = "Please check your internet connection."
        ///
        static let noRecord = "No record found."
        ///
        static let somethingWrong = "Something went wrong."
    }

    // MARK: - Button title strings
    ///
    struct Button {
        ///
        static let okButton = "OK"
        ///
        static let cancelButton = "Cancel"
        ///
        static let yesButton = "Yes"
        ///
        static let noButton = "No"
    }
    
    // MARK: - Login Screen Messages
    ///
    struct LoginScreen {
        ///
        static let strEmailAndPassValidMsg = "You must enter a valid email address and password."
        ///
        static let strEmailIdMsg = "Please enter an email address."
        ///
        static let strValidEmailIdMsg = "Please enter a valid email address."
        ///
        static let strpasswordMsg = "Please enter password."
        ///
        static let strValidpasswordMsg = "password must be at least 8 characters long."
    }
    
    struct UserDetails {
        ///
        static let strFirstNameMsg = "Please enter first name."
        ///
        static let strLastNameMsg = "Please enter last name."
        ///
        static let strDescriptionMsg = "Please enter description."
        ///
        static let strProfileColorMsg = "Please profile color."
    }
}
