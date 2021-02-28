//
//  LoginVC.swift
//  PiyushSinrojaPractical
//
//  Created by Admin on 18/02/21.
//

import UIKit
import JVFloatLabeledTextField
import Firebase
import FirebaseDatabase

class LoginVC: UIViewController {

    // MARK: - IBOutlet
    
    @IBOutlet weak var textFieldEmail: JVFloatLabeledTextField!
    @IBOutlet weak var textFieldPassword: JVFloatLabeledTextField!
    
    // MARK: - View Controller LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    func setupView() {
        setupTextfields(textFields: [textFieldEmail, textFieldPassword])
    }
    
    func setupTextfields(textFields: [UITextField]) {
        for textField in textFields {
            let paddingView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 20))
            textField.leftView = paddingView
            textField.leftViewMode = .always
        }
    }
    
    
    // MARK: - IBAction

    @IBAction func btnLoginAction(_ sender: Any) {
        
//        let userListVC = UIStoryboard.storyboard(.main).instantiateViewController(UserListVC.self)
//        self.navigationController?.pushViewController(userListVC, animated: true)
        
        let email = textFieldEmail.text?.removeWhiteSpace() ?? ""
        let password = textFieldPassword.text?.removeWhiteSpace() ?? ""
        validation(email: email, password: password, completion: { [weak self] (isValid, message) in
            guard isValid else {
                self?.showAlert(message: message, buttonTitle: Messages.Button.okButton, completion: {})
                return
            }
            self?.view.endEditing(true)
            self?.loginFirebase(email: email, password: password)
        })
    }
    
    @IBAction func btnBackAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Helper Methods

    func loginFirebase(email: String, password: String) {
        ProgressLoader.showProgressHudWithMessage()
        
        Auth.auth().signIn(withEmail: email, password: password, completion: { (authResult, error) in
            
            ProgressLoader.hideProgressHud()
            
            if let err: Error = error {
                self.showAlert("Login Unsuccessful", message: "\(err.localizedDescription)")
                return
            }
            if let useragain = Auth.auth().currentUser {
                print(useragain.displayName ?? "")
                print(useragain.uid)
                print(useragain.email ?? "")
                print(useragain.photoURL ?? "")

                if let name = useragain.displayName {
                    print(name)
                }

                if let urlphoto = useragain.photoURL {
                    print(urlphoto)
                }
                
                let userListVC = UIStoryboard.storyboard(.main).instantiateViewController(UserListVC.self)
                self.navigationController?.pushViewController(userListVC, animated: true)
            }
        })
    }
    
    // MARK: - Validation Login
    
    ///
    /// Validation for login
    ///
    /// - Parameter completion: completion return with bool and message string
    func validation(email: String, password: String, completion: @escaping (Bool, String) -> Void) {
        if email.isEmpty && password.isEmpty {
            completion(false, Messages.LoginScreen.strEmailAndPassValidMsg)
        } else if email.removeWhiteSpace().isEmpty {
            completion (false, Messages.LoginScreen.strEmailIdMsg)
        } else if email.isValidEmail() == false {
            completion (false, Messages.LoginScreen.strValidEmailIdMsg)
        } else if password.removeWhiteSpace().isEmpty {
            completion (false, Messages.LoginScreen.strpasswordMsg)
        } else {
            completion (true, "")
        }
    }
}
