//
//  CustonContactTableViewCell.swift
//  CustomContactApp
//
//  Created by Asif Taher on 3/25/19.
//  Copyright © 2019 Asif Taher. All rights reserved.
//

import UIKit
protocol CustomContactCellButtonProtocol: class{
    func didPressCustomCellButton(_ tag: Int)
}
class CustonContactTableViewCell: UITableViewCell {

    @IBOutlet weak var moreButton: UIButton!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var batchLabel: UILabel!
    @IBOutlet weak var workPlaceLabel: UILabel!
    @IBOutlet weak var presentPostLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    static let cellIdentifier: String = "customContactCellID"
    weak var customContactCellButtonDelegate: CustomContactCellButtonProtocol?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.updateUI()
        // Initialization code
    }
    @IBAction func moreButtonAction(_ sender: UIButton) {
        customContactCellButtonDelegate?.didPressCustomCellButton(sender.tag)
    }
    fileprivate func updateUI(){
        userImageView.layer.borderWidth = 1
        userImageView.layer.masksToBounds = false
        userImageView.layer.borderColor = UIColor.black.cgColor
        userImageView.layer.cornerRadius = userImageView.frame.height/2
        userImageView.clipsToBounds = true
        self.batchLabel.isHidden = true
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
