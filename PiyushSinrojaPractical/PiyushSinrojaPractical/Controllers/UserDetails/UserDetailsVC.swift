//
//  UserDetailsVC.swift
//  PiyushSinrojaPractical
//
//  Created by Admin on 18/02/21.
//

import UIKit
import JVFloatLabeledTextField
import Firebase
import FirebaseDatabase
import SwiftyJSON

class UserDetailsVC: UIViewController {

    // MARK: - IBOutlets
    
    @IBOutlet weak var textFieldEmail: JVFloatLabeledTextField!
    @IBOutlet weak var textFieldFirstName: JVFloatLabeledTextField!
    @IBOutlet weak var textFieldLastName: JVFloatLabeledTextField!
    @IBOutlet weak var textFieldDescription: JVFloatLabeledTextField!
    @IBOutlet weak var textFieldProfileColor: JVFloatLabeledTextField!
    
    @IBOutlet weak var btnAddUpdate: UIButton!
    
    // MARK: - Variables
    
    var isEditUser = false
    
    private var refHandle: DatabaseHandle?
    
    var userDetailsModel: UserDetailsModel?
    
    // MARK: - ViewController LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        displayData()
    }
    
    func setupView() {
        if isEditUser {
            btnAddUpdate.setTitle("UPDATE", for: .normal)
        } else {
            btnAddUpdate.setTitle("ADD", for: .normal)
        }
        setupTextfields(textFields: [textFieldEmail, textFieldFirstName, textFieldLastName, textFieldDescription, textFieldProfileColor])
    }

    func setupTextfields(textFields: [UITextField]) {
        for textField in textFields {
            let paddingView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 20))
            textField.leftView = paddingView
            textField.leftViewMode = .always
        }
    }
    
    // MARK: - IBActions
    
    @IBAction func btnUpdateAction(_ sender: Any) {
        let email = textFieldEmail.text?.removeWhiteSpace() ?? ""
        let firstName = textFieldFirstName.text?.removeWhiteSpace() ?? ""
        let lastName = textFieldLastName.text?.removeWhiteSpace() ?? ""
        let description = textFieldDescription.text?.removeWhiteSpace() ?? ""
        let profileColor = textFieldProfileColor.text?.removeWhiteSpace() ?? ""
        
        userDetailsModel = isEditUser ? userDetailsModel : UserDetailsModel()
        
        userDetailsModel?.email = email
        userDetailsModel?.firstName = firstName
        userDetailsModel?.lastName = lastName
        userDetailsModel?.descri = description
        userDetailsModel?.profileColor = profileColor
        
        if isEditUser {
            updateUserDataToStorage()
        } else {
            addUserDataToStorage()
        }
    }

    @IBAction func btnBackAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }

    // MARK: - Helper Methods
    
    func addUserDataToStorage() {
        if let userDetail = userDetailsModel {
            validation(userDetailsModel: userDetail, completion: { [weak self] (isValid, message) in
                guard isValid else {
                    self?.showAlert(message: message, buttonTitle: Messages.Button.okButton, completion: {})
                    return
                }
                self?.view.endEditing(true)
                self?.addUserIntoFireBaseStorage(userDetailsModel: userDetail)
            })
        }
    }
    
    func updateUserDataToStorage() {
        if let userDetail = userDetailsModel {
            validation(userDetailsModel: userDetail, completion: { [weak self] (isValid, message) in
                guard isValid else {
                    self?.showAlert(message: message, buttonTitle: Messages.Button.okButton, completion: {})
                    return
                }
                self?.view.endEditing(true)
                self?.updateUserIntoFireBaseStorage(userDetailsModel: userDetail)
            })
        }
    }
    
    func displayData() {
        if let userDetailsModel = userDetailsModel, isEditUser {
            textFieldEmail.text = userDetailsModel.email
            textFieldFirstName.text = userDetailsModel.firstName
            textFieldLastName.text = userDetailsModel.lastName
            textFieldDescription.text = userDetailsModel.descri
            textFieldProfileColor.text = userDetailsModel.profileColor
        }
    }
    
    func updateOtherDetails() {
        let user = Auth.auth().currentUser
        if let user = user {
            let changeRequest = user.createProfileChangeRequest()
            changeRequest.displayName = "Amazing"
            changeRequest.commitChanges { error in
                
                if error != nil {
                    print("Register successful!\n Your User id is \(user.uid)")
                   
                } else {
                   // self.updateDetailToDatabase()
                }
            }
        }
    }
    
    func addUserIntoFireBaseStorage(userDetailsModel: UserDetailsModel) {
        
        if let user = Auth.auth().currentUser {
            let refUserProfile = Database.database().reference(withPath: user.uid).child("UserList")
            
            guard let key = refUserProfile.childByAutoId().key else { return }
            
            let finalModel = userDetailsModel
            
            finalModel.recordKey = key
                
            let dicData = finalModel.getUserDetails()
            
            refUserProfile.child(key).setValue(dicData)
            
            navigationController?.popViewController(animated: true)
        }
    }
    
    func updateUserIntoFireBaseStorage(userDetailsModel: UserDetailsModel) {
        if let user = Auth.auth().currentUser {
            
            let refUserProfile = Database.database().reference(withPath: user.uid).child("UserList")
            
            let dicData = userDetailsModel.getUserDetails()
            
            refUserProfile.child(userDetailsModel.recordKey).setValue(dicData)
            
            navigationController?.popViewController(animated: true)
        }
    }
    
    // MARK: - Validation
    
    func validation(userDetailsModel: UserDetailsModel, completion: @escaping (Bool, String) -> Void) {
        if userDetailsModel.email.isEmpty {
            completion (false, Messages.LoginScreen.strEmailIdMsg)
        } else if userDetailsModel.email.isValidEmail() == false {
            completion (false, Messages.LoginScreen.strValidEmailIdMsg)
        } else if userDetailsModel.firstName.isEmpty {
            completion (false, Messages.UserDetails.strFirstNameMsg)
        } else if userDetailsModel.lastName.isEmpty {
            completion (false, Messages.UserDetails.strLastNameMsg)
        } else if userDetailsModel.descri.isEmpty {
            completion (false, Messages.UserDetails.strDescriptionMsg)
        } else if userDetailsModel.profileColor.isEmpty {
            completion (false, Messages.UserDetails.strProfileColorMsg)
        }  else {
            completion (true, "")
        }
    }
}
