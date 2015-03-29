//
//  LoginVC.swift
//  AllMyThings
//
//  Created by Kareem Khattab on 3/24/15.
//  Copyright (c) 2015 Kareem Khattab. All rights reserved.
//

import UIKit

class LoginVC: UIViewController, UITextFieldDelegate {

    @IBOutlet var titleLbl: UILabel!
    
    @IBOutlet var emailTxtField: UITextField!
    
    @IBOutlet var passwordTxtField: UITextField!
    
    @IBOutlet var loginBtn: UIButton!
    
    @IBOutlet var signUpBtn: UIButton!
    
    
    @IBOutlet var legalTxtView: UITextView!
    
    
    @IBAction func cancelToLoginViewController(segue:UIStoryboardSegue) {
        
        dismissViewControllerAnimated(true, completion: nil)

    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let theWidth = view.frame.size.width
        let theHeight = view.frame.size.height
        
        
        // Optimizing the login screen for all devices
        
        titleLbl.center = CGPointMake(theWidth/2, 130)
        emailTxtField.frame = CGRectMake(16, 200, theWidth - 32 , 30)
        passwordTxtField.frame = CGRectMake(16, 240, theWidth - 32, 30)
        loginBtn.center = CGPointMake(theWidth/2, 330)
        signUpBtn.center = CGPointMake(theWidth/2, 375)
        legalTxtView.center = CGPointMake(theWidth/2, theHeight - 30)

        
        //Setting the delegate for the textfields so we can use UITextFieldDelegate which I imported
        self.emailTxtField.delegate = self
        self.passwordTxtField.delegate = self
        
        // Place holder text for the email and password field
        emailTxtField.attributedPlaceholder = NSAttributedString(string: "Enter Email", attributes: [NSForegroundColorAttributeName: UIColor.darkGrayColor()])
        passwordTxtField.attributedPlaceholder = NSAttributedString(string: "Enter Password", attributes: [NSForegroundColorAttributeName: UIColor.darkGrayColor()])
        

       
       
    }
    // Will hide the navigation bar at the top
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.navigationBarHidden = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
    @IBAction func userLoginAction(sender: AnyObject) {
        
        
        PFUser.logInWithUsernameInBackground(emailTxtField.text, password: passwordTxtField.text) {
            (user:PFUser!, error:NSError!) -> Void in
            
            if error == nil {
                
                
                //Takes user to homescreen if the login did not fail
                
                println("Log in successful")
                
                var installation: PFInstallation = PFInstallation.currentInstallation()
                installation.addUniqueObject("Reload", forKey: "channels")
                installation["user"] = PFUser.currentUser()
                installation.saveInBackgroundWithTarget(nil , selector: nil)
                
                self.performSegueWithIdentifier("goToApp1", sender: self)
                
                
            }
            else {
                // Alert the user if the Login Failed
                println("Login Failed")
                var myAlert = UIAlertController()
                let alertController = UIAlertController(title: "Login Failed", message: "Sorry, there was an error in your Username or Password.", preferredStyle: .Alert)
                
                
                let OKAction = UIAlertAction(title: "OK", style: .Default) { (action) in
                    // ...
                }
                alertController.addAction(OKAction)
                
                self.presentViewController(alertController, animated: true) {
                    // ...
                }
                
                
            }
            
        }

    }
    
    
    
    
    
 

    // makes the text field you click the first responder and resigns it when you hit enter
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if (textField == self.emailTxtField) {
            self.emailTxtField?.resignFirstResponder()
            self.passwordTxtField?.becomeFirstResponder()
        } else if (textField == self.passwordTxtField) {
            self.passwordTxtField?.resignFirstResponder()
            
        }
        
        return true
        
    }
    
    // This function dismisses the keyboard when you click anywhere
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        self.view.endEditing(true)
    }

}
