//
//  UserChatTableViewCell.swift
//  Chat
//
//  Created by iOS on 7/4/17.
//  Copyright © 2017 Spencer Wallsworth. All rights reserved.
//

import UIKit

class UserChatTableViewCell: UITableViewCell {

    @IBOutlet  weak var profileImageView: UIImageView!

    
    @IBOutlet  weak var userName: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }


    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
