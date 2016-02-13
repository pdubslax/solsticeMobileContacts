//
//  MainTableViewCell.swift
//  solsticeContacts
//
//  Created by Patrick Wilson on 2/12/16.
//  Copyright © 2016 Patrick Wilson. All rights reserved.
//

import UIKit

class MainTableViewCell: UITableViewCell {
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var mainImageView: UIImageView!
    
    @IBOutlet var phoneLabel: UILabel!
    override func awakeFromNib() {
        
        super.awakeFromNib()
        self.mainImageView.contentMode = .ScaleAspectFit
        self.mainImageView.layer.cornerRadius = self.mainImageView.frame.size.width / 2
        self.mainImageView.clipsToBounds = true
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    
    
    
    
}
