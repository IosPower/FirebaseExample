//
//  UserListVC.swift
//  PiyushSinrojaPractical
//
//  Created by Admin on 18/02/21.
//

import UIKit
import Firebase
import SwiftyJSON
class UserListVC: UIViewController {

    // MARK: - IBOutlets
    
    @IBOutlet weak var tblViewUserList: UITableView!
    
    // MARK: - Variables
    
    ///
    private var refHandle: DatabaseHandle?
    ///
    var arrUserDetails: [UserDetailsModel] = []
    ///
    var refreshController = UIRefreshControl()
    
    // MARK: - ViewController LifeCycles
    
    ///
    override func viewDidLoad() {
        super.viewDidLoad()
        addPullToRefresh()
        displayUserListData()
    }
    
    // MARK: - IBActions
    
    @IBAction func btnAddUserAction(_ sender: Any) {
        let userDetailsVC = UIStoryboard.storyboard(.main).instantiateViewController(UserDetailsVC.self)
        navigationController?.pushViewController(userDetailsVC, animated: true)
    }
    
    @IBAction func btnSignOutAction(_ sender: Any) {
        if signOut() {
            let registerVC = UIStoryboard.storyboard(.main).instantiateViewController(RegisterVC.self)
            navigationController?.pushViewController(registerVC, animated: true)
        }
    }
    
    // MARK: - Helper Methods
    
    /// fetch user list from firebase dabase and display
    func displayUserListData() {
        
        let user = Auth.auth().currentUser
        
        if let userId = user?.uid {
            
            let ref = Database.database().reference(withPath: userId).child("UserList")
            
            ProgressLoader.showProgressHudWithMessage()
            
            refHandle = ref.observe(.value, with: { [weak self] (snapshot) -> Void in
                ProgressLoader.hideProgressHud()
                if let dicDetails: NSDictionary = snapshot.value as? NSDictionary {
                    
                    print("dicDetails", dicDetails)

                    let arrModel = dicDetails.allValues
                    
                    let arrData = arrModel.map({UserDetailsModel(json: JSON($0))})
                    
                    self?.arrUserDetails = arrData
                    
                } else {
                    self?.arrUserDetails = []
                }
                self?.tblViewUserList.reloadData()
            })
        }
        
    }
    
    /// sign out
    /// - Returns: bool value
    func signOut() -> Bool {
        do{
            try Auth.auth().signOut()
            return true
        } catch {
            return false
        }
    }
    
    func deletePost(model: UserDetailsModel) {
        let user = Auth.auth().currentUser
        if let userId = user?.uid {
            let ref = Database.database().reference(withPath: userId).child("UserList")
            ref.child(model.recordKey).removeValue { (error, ref) in
                if let err = error {
                    print("error \(err.localizedDescription)")
                }
            }
        }
    }
    
    func addPullToRefresh(){
        
        refreshController.bounds = CGRect(x: 0, y: 50, width: refreshController.bounds.size.width, height: refreshController.bounds.size.height)
        refreshController.addTarget(self, action: #selector(refreshListData), for: .valueChanged)
        tblViewUserList.addSubview(refreshController)
    }

    @objc func refreshListData(refresh: UIRefreshControl) {
        displayUserListData()
        refresh.endRefreshing()
    }
}

// MARK: - UITableViewDataSource
extension UserListVC: UITableViewDataSource {
    ///
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrUserDetails.count
    }
    ///
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tblViewUserList?.dequeueReusableCell(withIdentifier: "UserListTableCell", for: indexPath) as? UserListTableCell else { return UITableViewCell() }
        
        let model = arrUserDetails[indexPath.row]
        
        cell.lblEmailValue.text = model.email
        cell.lblUserNameValue.text = model.firstName + " " + model.lastName
        cell.lblDescriptionValue.text = model.descri
        cell.lblColorValue.text = model.profileColor
        
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let model = arrUserDetails[indexPath.row]
            deletePost(model: model)
           // tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
}

// MARK: - UITableViewDelegate
extension UserListVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let userDetailsVC = UIStoryboard.storyboard(.main).instantiateViewController(UserDetailsVC.self)
        userDetailsVC.isEditUser = true
        userDetailsVC.userDetailsModel = arrUserDetails[indexPath.row]
        navigationController?.pushViewController(userDetailsVC, animated: true)
    }
}
