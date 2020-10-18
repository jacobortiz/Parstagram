//
//  PostCell.swift
//  Parstagram
//
//  Created by Jacob Ortiz on 10/17/20.
//  Copyright © 2020 jacobortiz. All rights reserved.
//

import UIKit

class PostCell: UITableViewCell {

    @IBOutlet weak var photo_view: UIImageView!
    @IBOutlet weak var username_label: UILabel!
    @IBOutlet weak var caption_label: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
