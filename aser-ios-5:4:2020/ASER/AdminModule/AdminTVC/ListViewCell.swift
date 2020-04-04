//
//  ListViewCell.swift
//  ASER
//
//  Created by Ankit Kumar on 12/01/20.
//  Copyright © 2020 Priti Sharma. All rights reserved.
//

import UIKit

class ListViewCell: UITableViewCell {

    //MARK:- Outlets
    
    @IBOutlet weak var questionLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }


}
