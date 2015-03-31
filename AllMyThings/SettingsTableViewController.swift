//
//  SettingsTableViewController.swift
//  AllMyThings
//
//  Created by Kareem Khattab on 3/28/15.
//  Copyright (c) 2015 Kareem Khattab. All rights reserved.
//

import UIKit
import Foundation

class SettingsTableViewController: UITableViewController, UINavigationControllerDelegate {
    
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

    
    override func viewWillAppear(animated: Bool) {
        // Start color off with a default value
        var color = UIColor.groupTableViewBackgroundColor()
        view.backgroundColor = color
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
   
    @IBAction func logOutUser(sender: AnyObject) {
        
        
        PFUser.logOut()
        //we dont want to use a push , bad practice so i have added this code to get us out of the app
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewControllerWithIdentifier("SignInViewController") as UIViewController
        self.presentViewController(vc, animated: true, completion: nil)
        println("log out")
        
        
    }
    
    @IBAction func toggleSideMenu(sender: AnyObject) {
        toggleSideMenuView()
    }
    //work in progress
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
      
        
        var title: UILabel = UILabel()
       
      
        if section == 0{
          
           
            title.text = "Account"
            title.textColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.8)
            title.backgroundColor = UIColor.groupTableViewBackgroundColor()
            title.font = UIFont.boldSystemFontOfSize(15)
            
            
        }
        else if section == 1
        {
            
            title.text = "Security"
            title.textColor = UIColor.blackColor()
            title.backgroundColor = UIColor.groupTableViewBackgroundColor()
            title.font = UIFont.boldSystemFontOfSize(15)
            
    
        }
        
       
        
        return title
    }
    override func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        var title: UILabel = UILabel()
       
       
        if section == 1
        {
            
            title.text = "Version 1.0.0"
            title.textColor = UIColor.blackColor()
            title.backgroundColor = UIColor.groupTableViewBackgroundColor()
            title.font = UIFont(name: "Arial", size: 14)!
            title.textAlignment = .Right
            
            
            
        }

        return title
    }
    
    
}
