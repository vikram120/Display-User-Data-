//
//  CustomTVC.swift
//  NewApp
//
//  Created by Trycatch Classes on 15/02/22.
//

import UIKit

class CustomTVC: UITableViewCell {
    
    
    @IBOutlet weak var genderImageView: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var emailButton: UIButton!
    
    @IBOutlet weak var deleteButton: UIButton!
    
    @IBOutlet weak var statusView: UIView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
