//
//  RegisterVC.swift
//  PiyushSinrojaPractical
//
//  Created by Admin on 18/02/21.
//

import UIKit
import Firebase
import FirebaseDatabase
import JVFloatLabeledTextField

class RegisterVC: UIViewController {

    // MARK: - IBOutlets
    
    @IBOutlet weak var textFieldEmail: JVFloatLabeledTextField!
    @IBOutlet weak var textFieldPassword: JVFloatLabeledTextField!
    
    // MARK: - ViewController LifeCycles
    
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
    
    // MARK: - IBActions
    
    @IBAction func btnLoginAction(_ sender: Any) {
        let loginVc = UIStoryboard.storyboard(.main).instantiateViewController(LoginVC.self)
        navigationController?.pushViewController(loginVc, animated: true)
    }
    
    @IBAction func btnRegisterAction(_ sender: Any) {
        let email = textFieldEmail.text?.removeWhiteSpace() ?? ""
        let password = textFieldPassword.text?.removeWhiteSpace() ?? ""
        validation(email: email, password: password, completion: { [weak self] (isValid, message) in
            guard isValid else {
                self?.showAlert(message: message, buttonTitle: Messages.Button.okButton, completion: {})
                return
            }
            self?.view.endEditing(true)
            self?.registerWithFirebase(email: email, password: password)
        })
    }
  
    // MARK: - Validation
    
    ///
    /// Validation for register
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
    
    // MARK: - Helper Methods
    
    private func registerWithFirebase(email: String, password: String) {
        ProgressLoader.showProgressHudWithMessage()
        Auth.auth().createUser(withEmail: email, password: password) { (_, error) in
            ProgressLoader.hideProgressHud()
            
            if let err: Error = error {
                self.showAlert("Register Unsuccessful", message: "\(err.localizedDescription)")
                return
            }
            
            let userListVC = UIStoryboard.storyboard(.main).instantiateViewController(UserListVC.self)
            self.navigationController?.pushViewController(userListVC, animated: true)
        }
    }
}
