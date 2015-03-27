//
//  HomeTableCell.swift
//  AllMyThings
//
//  Created by Kareem Khattab on 3/24/15.
//  Copyright (c) 2015 Kareem Khattab. All rights reserved.
//

import UIKit

class HomeTableCell: UITableViewCell {

    
    @IBOutlet weak var nameTxtField: UITextField!
    
    @IBOutlet weak var typeTxtField: UITextField!
  
    @IBOutlet weak var timeStampLbl: UILabel!
    
    @IBOutlet weak var usernameLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
      
        
        

    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
