//
//  NameDetailTableViewCell.swift
//  solsticeContacts
//
//  Created by Patrick Wilson on 2/13/16.
//  Copyright © 2016 Patrick Wilson. All rights reserved.
//

import UIKit

class NameDetailTableViewCell: UITableViewCell {
    
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var companyLabel: UILabel!
    @IBOutlet var bigImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.bigImageView.contentMode = .ScaleAspectFit
        self.bigImageView.layer.cornerRadius = self.bigImageView.frame.size.width / 2
        self.bigImageView.clipsToBounds = true
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
