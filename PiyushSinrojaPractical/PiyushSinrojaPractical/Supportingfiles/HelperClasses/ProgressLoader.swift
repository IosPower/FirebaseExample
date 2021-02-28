//
//  ProgressLoader.swift
//  PiyushSinrojaPractical
//
//  Created by Admin on 18/02/21.
//

import UIKit

import SVProgressHUD

class ProgressLoader: NSObject {
        
    class func showProgressHudWithMessage(message: String = "Loading", isForError: Bool = false) {
        
        SVProgressHUD.setDefaultAnimationType(SVProgressHUDAnimationType.native)
        
        SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.black)
        
        if isForError {
            SVProgressHUD.showError(withStatus: message)
        } else {
            SVProgressHUD.show(withStatus: message)
        }
    }
    
    class func hideProgressHud() {
        SVProgressHUD.dismiss()
    }
}
