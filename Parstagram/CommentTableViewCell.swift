//
//  CommentTableViewCell.swift
//  Parstagram
//
//  Created by Jacob Ortiz on 10/18/20.
//  Copyright © 2020 jacobortiz. All rights reserved.
//

import UIKit

class CommentTableViewCell: UITableViewCell {
    
    @IBOutlet weak var username_label: UILabel!
    @IBOutlet weak var comment_label: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
