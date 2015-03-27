//
//  SignUpVC.swift
//  AllMyThings
//
//  Created by Kareem Khattab on 3/24/15.
//  Copyright (c) 2015 Kareem Khattab. All rights reserved.
//

import UIKit

class SignUpVC: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextFieldDelegate  {

    @IBOutlet var profilePic: UIImageView!
    
    @IBOutlet var addPhotoBtn: UIButton!
    
    @IBOutlet var emailTxtField: UITextField!
    
    @IBOutlet var passwordTxtField: UITextField!
    
    @IBOutlet var firstNameField: UITextField!
    
    @IBOutlet var signUpBtn: UIButton!
    
    @IBOutlet var cancelBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let theWidth = view.frame.size.width
        let theHeight = view.frame.size.height
        
        // making the profile picture circular
        profilePic.center = CGPointMake(theWidth/2, 140)
        profilePic.layer.cornerRadius = profilePic.frame.size.width/2
        profilePic.clipsToBounds = true
        
        
        // optimizing the app for all devices
        addPhotoBtn.center = CGPointMake(self.profilePic.frame.maxX + 50, 140)
        emailTxtField.frame = CGRectMake(16, 240, theWidth-32, 30)
        passwordTxtField.frame = CGRectMake(16, 280, theWidth-32, 30)
        firstNameField.frame = CGRectMake(16, 320, theWidth-32, 30)
        signUpBtn.center = CGPointMake(theWidth/2, 380 )
        cancelBtn.center = CGPointMake(theWidth/2, 410)

        
        //text field 
        
        emailTxtField.delegate = self
        passwordTxtField.delegate = self
        firstNameField.delegate = self
        
        firstNameField.attributedPlaceholder = NSAttributedString(string:"Enter Full Name",
            attributes:[NSForegroundColorAttributeName: UIColor.darkGrayColor()])
        
        passwordTxtField.attributedPlaceholder = NSAttributedString(string:"Enter Password",
            attributes:[NSForegroundColorAttributeName: UIColor.darkGrayColor()])
        
        emailTxtField.attributedPlaceholder = NSAttributedString(string:"Enter Email",
            attributes:[NSForegroundColorAttributeName: UIColor.darkGrayColor()])


        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Will hide the navigation bar on top 
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.navigationBarHidden = true
    }
  
    // Profile Image functions
   
    @IBAction func addImgBtn(sender: AnyObject) {
        
        var image = UIImagePickerController()
        image.delegate = self
        image.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        image.allowsEditing = true
        self.presentViewController(image, animated: true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController!, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {
        
        profilePic.image = image
        self.dismissViewControllerAnimated(true, completion: nil)
        
        
    }


    // Edit text field functions
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        emailTxtField.resignFirstResponder()
        passwordTxtField.resignFirstResponder()
        firstNameField.resignFirstResponder()
        
        return true
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        
        self.view.endEditing(true)
    }
    
    
    func textFieldDidBeginEditing(textField: UITextField) {
        
        let theWidth = view.frame.size.width
        let theHeight = view.frame.size.height
        //animates the fields by pushing it up if the keyboard covers the text field
        if(UIScreen.mainScreen().bounds.height == 568)
        {
            if(textField == firstNameField)
            {
                
                UIView.animateWithDuration(0.3, delay: 0, options: .CurveLinear, animations: {
                    
                    self.view.center = CGPointMake(theWidth/2, theHeight/2-40)
                    
                    }, completion: {
                        (finished:Bool) in
                        //
                        
                })
                
                
            }
        }
        
    }
    
    
    func textFieldDidEndEditing(textField: UITextField) {
        let theWidth = view.frame.size.width
        let theHeight = view.frame.size.height
        //returns the fields to where they were before keyboard
        if(UIScreen.mainScreen().bounds.height == 568)
        {
            if(textField == firstNameField)
            {
                
                UIView.animateWithDuration(0.3, delay: 0, options: .CurveLinear, animations: {
                    
                    self.view.center = CGPointMake(theWidth/2, theHeight/2)
                    
                    }, completion: {
                        (finished:Bool) in
                        //
                        
                })
                
                
            }
        }
        
    }
    

    @IBAction func signUpUser(sender: AnyObject) {
        
        // creating the new user 
        var user = PFUser()
        user.username = emailTxtField.text
        user.password = passwordTxtField.text
        user.email = emailTxtField.text
        user["profileName"] = firstNameField.text
        
        // If user seleceted a profile image save it
        if(profilePic.image != nil)
        {
        let imageData = UIImagePNGRepresentation(self.profilePic.image)
        let imageFile = PFFile(name:"profilePicture.png", data: imageData)
        user["photo"] = imageFile
        }
        
        user.signUpInBackgroundWithBlock{
            (succeeded:Bool! , error: NSError!) -> Void in
            
            if error == nil {
                println("Sign Up Successful")
                
                // Keep track of the installs of our app
                var installation: PFInstallation = PFInstallation.currentInstallation()
                installation.addUniqueObject("Reload", forKey: "channels")
                installation["user"] = PFUser.currentUser()
                installation.saveInBackgroundWithTarget(nil , selector: nil)

                
                self.performSegueWithIdentifier("goToApp2", sender: self)
            }
            else {
                println("Error Sign Up")
                
            
                //If email has been used for another account
                if(error.code == kPFErrorUserEmailTaken) {
                    
                    let alertController = UIAlertController(title: "Sign Up Failed", message: "Sorry! Email has been taken! ", preferredStyle: .Alert)
                    
                    
                    let OKAction = UIAlertAction(title: "OK", style: .Default) { (action) in
                        // ...
                    }
                    alertController.addAction(OKAction)
                    
                    self.presentViewController(alertController, animated: true) {
                        // ...
                    }
                }
                    //If user does not enter a valid email at sign up for example "@gmail.com"
                else if(error.code == kPFErrorInvalidEmailAddress)
                {
                    let alertController = UIAlertController(title: "Sign Up Failed", message: "Please enter a valid email address! ", preferredStyle: .Alert)
                    
                    
                    let OKAction = UIAlertAction(title: "OK", style: .Default) { (action) in
                        // ...
                    }
                    alertController.addAction(OKAction)
                    
                    self.presentViewController(alertController, animated: true) {
                        // ...
                    }
                    
                }
                else if (self.profilePic.image == nil) {
                    let alertController = UIAlertController(title: "Sign Up Failed", message: "Sorry! Please select a profile image", preferredStyle: .Alert)
                    
                    
                    let OKAction = UIAlertAction(title: "OK", style: .Default) { (action) in
                        // ...
                    }
                    alertController.addAction(OKAction)
                    
                    self.presentViewController(alertController, animated: true) {
                        // ...
                    }
                    
                }
                
                else {
                    let alertController = UIAlertController(title: "Sign Up Failed", message: "Sorry! Fill out all Fields!", preferredStyle: .Alert)
                    
                    
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

    }
    
    // Takes you back to the login screen
    @IBAction func cancelBtn(sender: AnyObject) {
        
        self.navigationController?.popViewControllerAnimated(true)

    }

}
