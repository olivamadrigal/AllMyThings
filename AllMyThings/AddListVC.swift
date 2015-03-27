//
//  AddListVC.swift
//  AllMyThings
//
//  Created by Kareem Khattab on 3/24/15.
//  Copyright (c) 2015 Kareem Khattab. All rights reserved.
//

import UIKit

class AddListVC: UITableViewController, UITextFieldDelegate {


    @IBOutlet weak var nameTextField: UITextField!
    
    @IBOutlet weak var typeTextField: UITextField!
   
    // Saves the list to the parse data base and then takes us back to the previous screen
    @IBAction func saveListToParse(sender: AnyObject) {
        
        
        if(nameTextField.text != "" && typeTextField.text != "")
        {
        var list:PFObject = PFObject(className: "List")
        list["Name"] = nameTextField.text
        list["Type"] = typeTextField.text
        list["Username"] = username
        list["User"] = PFUser.currentUser()
            
        list.saveInBackgroundWithTarget(nil , selector: nil)
            

        println("List saved")
         
            
        //hide the detail view controller
        dismissViewControllerAnimated(true, completion: nil)
        }
        else
        {
            // Alert the user if the user left the fields blank
            println("Save failed.")
            var myAlert = UIAlertController()
            let alertController = UIAlertController(title: "Could not save list! ", message: "Sorry, please fill out all the fields!", preferredStyle: .Alert)
            
            
            let OKAction = UIAlertAction(title: "OK", style: .Default) { (action) in
                // ...
            }
            alertController.addAction(OKAction)
            
            self.presentViewController(alertController, animated: true) {
                // ...
            }
            
            
        }

        
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        var attributes = [
            NSForegroundColorAttributeName: UIColor.whiteColor(),
            NSFontAttributeName: UIFont(name: "HelveticaNeue", size: 18)!
        ]
        self.navigationController?.navigationBar.titleTextAttributes = attributes
        self.navigationController?.navigationBar.barTintColor = UIColor.grayColor()
        

        
    }

    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.section == 0 {
            nameTextField.becomeFirstResponder()
        }
    }
    

}
