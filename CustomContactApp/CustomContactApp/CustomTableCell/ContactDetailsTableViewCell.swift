//
//  ContactDetailsTableViewCell.swift
//  CustomContactApp
//
//  Created by Guest User on 3/28/19.
//  Copyright © 2019 Asif Taher. All rights reserved.
//

import UIKit

class ContactDetailsTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    static let cellIdentifier: String = "customContactDetailsCellIdentifier"
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
