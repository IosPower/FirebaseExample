//
//  UserListTableCell.swift
//  PiyushSinrojaPractical
//
//  Created by Admin on 18/02/21.
//

import UIKit

class UserListTableCell: UITableViewCell {
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var lblEmailValue: UILabel!
    @IBOutlet weak var lblUserNameValue: UILabel!
    @IBOutlet weak var lblDescriptionValue: UILabel!
    @IBOutlet weak var lblColorValue: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
