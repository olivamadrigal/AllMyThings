//
//  ItemCell.swift
//  AllMyThings
//
//  Created by Kareem Khattab on 3/25/15.
//  Copyright (c) 2015 Kareem Khattab. All rights reserved.
//

import UIKit

class ItemCell: UITableViewCell {

    @IBOutlet weak var itemNameTxtField: UITextField!
    
    @IBOutlet weak var itemPicture: UIImageView!
    
    @IBOutlet weak var itemNoteTextField: UITextView!
    
    @IBOutlet weak var listNameLbl: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
         self.listNameLbl.text = listName
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
