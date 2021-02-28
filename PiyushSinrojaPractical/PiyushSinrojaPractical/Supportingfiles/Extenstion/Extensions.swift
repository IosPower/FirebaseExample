//
//  Extensions.swift
//  PiyushSinrojaPractical
//
//  Created by Admin on 18/02/21.
//

import UIKit

extension String {
    /// Trim string from left & right side extra spaces.
    ///
    /// - Returns: final string after removing extra left & right space.
    
    ///
    func removeWhiteSpace() -> String {
        return self.trimmingCharacters(in: .whitespaces)
    }
    
    // check valid mail
    func isValidEmail() -> Bool {
        if self.isEmpty {
            return false
        }
        let emailRegEx = "[.0-9a-zA-Z_-]+@[0-9a-zA-Z.-]+\\.[a-zA-Z]{2,20}"
        let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        if !emailTest.evaluate(with: self) {
            return false
        }
        return true
    }
    
    // check valid Password
    func isValidPassword() -> Bool {
        let passwordRegex = "^(?=.*\\d)(?=.*[a-z])(?=.*[A-Z])[0-9a-zA-Z!@#$£€§%…^&*\\/()\\[\\]\\-_=+{}|?>.<,:;~`'\"/\\\\]{8,128}$"
        return NSPredicate(format: "SELF MATCHES %@", passwordRegex).evaluate(with: self)
    }
    
}

extension UIViewController {
    /// common alert controller
    func showAlert(_ title: String = "Practical", message: String, buttonTitle: String = Messages.Button.okButton, completion: (() -> Void)? = nil) {
        DispatchQueue.main.async { [unowned self] in
            let alert: UIAlertController = UIAlertController(title: title, message: message, preferredStyle: .alert )
            let okAction = UIAlertAction(title: buttonTitle, style: .default, handler: { (_) in
                completion?()
            })
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
        }
    }
}

extension UINavigationController {

    func containsViewController(ofKind kind: AnyClass) -> Bool {
        return self.viewControllers.contains(where: { $0.isKind(of: kind) })
    }

    func popPushToVC(ofKind kind: AnyClass, pushController: UIViewController) {
        if containsViewController(ofKind: kind) {
            for controller in self.viewControllers {
                if controller.isKind(of: kind) {
                    popToViewController(controller, animated: true)
                    break
                }
            }
        } else {
            pushViewController(pushController, animated: true)
        }
    }
}

extension UIStoryboard {
    
    // MARK: - Convenience Initializers
    /// Storyboard initializer
    ///
    /// - Parameters:
    ///   - storyboard: will set storyboard name
    ///   - bundle: will set bundle identifier
    convenience init(storyboard: Storyboard, bundle: Bundle? = nil) {
        self.init(name: storyboard.filename, bundle: bundle)
    }
    
    // MARK: - Class Functions
    ///
    ///
    /// - Parameters:
    ///   - storyboard: will set storyboard name
    ///   - bundle: will set bundle identifier
    /// - Returns: will return storyboard
    class func storyboard(_ storyboard: Storyboard, bundle: Bundle? = nil) -> UIStoryboard {
        return UIStoryboard(name: storyboard.filename, bundle: bundle)
    }
    
    // MARK: - View Controller Instantiation from Generics
    ///
    func instantiateViewController<T>(_ identifier: T.Type) -> T where T: UIViewController {
        let className = String(describing: identifier)
        guard let viewController = self.instantiateViewController(withIdentifier: className) as? T else {
            fatalError("Couldn't instantiate view controller with identifier \(className) ")
        }
        return viewController
    }
}
