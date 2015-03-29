//
//  SettingsTableViewController.swift
//  AllMyThings
//
//  Created by Kareem Khattab on 3/28/15.
//  Copyright (c) 2015 Kareem Khattab. All rights reserved.
//

import UIKit

class SettingsTableViewController: UITableViewController, UINavigationControllerDelegate  {
    
    @IBOutlet weak var logOutBtn: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        
        var attributes = [
            NSForegroundColorAttributeName: UIColor.whiteColor(),
            NSFontAttributeName: UIFont(name: "HelveticaNeue", size: 18)!
        ]
        self.navigationController?.navigationBar.titleTextAttributes = attributes
        self.navigationController?.navigationBar.barTintColor = UIColor.grayColor()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
   
    @IBAction func logOutUser(sender: AnyObject) {
        
        
        PFUser.logOut()
        println("log out")
        
        
    }
}
