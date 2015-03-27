//
//  AddItemVC.swift
//  AllMyThings
//
//  Created by Kareem Khattab on 3/25/15.
//  Copyright (c) 2015 Kareem Khattab. All rights reserved.
//

import UIKit

class AddItemVC: UITableViewController, UIImagePickerControllerDelegate , UITextFieldDelegate, UINavigationControllerDelegate, UITextViewDelegate {

    @IBOutlet weak var itemNameTxtField: UITextField!
    
    @IBOutlet weak var addPhotoBtn: UIButton!
    
    @IBOutlet weak var takePhotoBtn: UIButton!
    
    @IBOutlet weak var itemImage: UIImageView!
    
    @IBOutlet weak var noteTxtView: UITextView!
    
    @IBOutlet weak var characterRemainingLbl: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // attributes for the noteTxtView
        noteTxtView.layer.borderColor = UIColor.blackColor().CGColor
        noteTxtView.layer.borderWidth = 0.5
        noteTxtView.layer.cornerRadius = 5
        self.noteTxtView.delegate = self
        // itemnameTxt field becoming the firsresponder and setting the delegate for the textfield functions
        itemNameTxtField.becomeFirstResponder()
        self.itemNameTxtField.delegate = self;
    }
    
    override func viewDidAppear(animated: Bool) {
        
        // hides the default back button
        self.navigationItem.hidesBackButton = true
        // navigation bar attributes
        var attributes = [
            NSForegroundColorAttributeName: UIColor.whiteColor(),
            NSFontAttributeName: UIFont(name: "HelveticaNeue", size: 18)!
        ]
        // set the title to the font attribute and color of the navigation bar to gray
        self.navigationController?.navigationBar.titleTextAttributes = attributes
        self.navigationController?.navigationBar.barTintColor = UIColor.grayColor()
        
        
    }
    
    // Image buttons
    
    
    @IBAction func takePhotoBtn(sender: AnyObject) {
        
        //check to see if the camera is available on the device
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera){
        
        // this will change the source to the camera and not the photo library
        var imagePicker:UIImagePickerController = UIImagePickerController()
        imagePicker.sourceType = UIImagePickerControllerSourceType.Camera
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        self.presentViewController(imagePicker, animated: true, completion: nil)
        }
        else
        {
            // handle the exception
            println("Camera is not available in simulator")
        }
    }
    
    @IBAction func addPhotoBtn(sender: AnyObject) {
        //photos to come from the photo library
        var imagePicker:UIImagePickerController = UIImagePickerController()
        imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        self.presentViewController(imagePicker, animated: true, completion: nil)
        
        
    }
    //assign the the image view to the photo that was chosen
    func imagePickerController(picker: UIImagePickerController!, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {
        
        
        itemImage.image = image
        self.dismissViewControllerAnimated(true, completion: nil)
        
        
    }

    
    // Text field and text view functions
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        itemNameTxtField.resignFirstResponder()
        

        
        
        return false
    }
    
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        
        self.view.endEditing(true)
    }
    
    


    
    func textView(textView: UITextView,
        shouldChangeTextInRange range: NSRange,
        replacementText text: String) -> Bool{
            
            
            var newLength:Int = (textView.text as NSString).length + (text as NSString).length - range.length
            var remainingChar:Int = 140 - newLength
            
            characterRemainingLbl.text = "\(remainingChar)"
            
            if text == "\n"
            {
                noteTxtView.resignFirstResponder()
                return false
            }
            
            return (newLength > 140) ? false : true
            
          
            
    }
    
    func textViewDidEndEditing(textView: UITextView) {
        let theWidth = view.frame.size.width
        let theHeight = view.frame.size.height
        
        if(UIScreen.mainScreen().bounds.height == 568 || UIScreen.mainScreen().bounds.height == 667)
        {
            if(textView == noteTxtView)
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
    
    func textViewDidBeginEditing(textView: UITextView) {
        
        let theWidth = view.frame.size.width
        let theHeight = view.frame.size.height
        
        if(UIScreen.mainScreen().bounds.height == 568 || UIScreen.mainScreen().bounds.height == 667)
        {
            if(textView == noteTxtView)
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
    
    //dismiss textView with a gesture 
    @IBAction func tapped(sender: AnyObject) {
        noteTxtView.resignFirstResponder()
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // Save the item to parse 
    
    
    @IBAction func saveItemToParse(sender: AnyObject) {
        
        if(itemNameTxtField.text != "" && noteTxtView.text != "" && itemImage.image != nil  )
        {
            var item:PFObject = PFObject(className: "Items")
            item["Name"] = itemNameTxtField.text
            item["Notes"] = noteTxtView.text
            item["List"] = listName
            item["Username"] = PFUser.currentUser().username
            let image = itemImage.image
            let imageData = UIImagePNGRepresentation(image)
            let imageFile:PFFile = PFFile(name: "itemImage", data: imageData )
            item["Image"] = imageFile
        
            
            item.saveInBackgroundWithTarget(nil , selector: nil)
            
            
            println("item saved")
            
            
            //takes you back to the previous view controller *not the rootview controller
            navigationController?.popViewControllerAnimated(true)
            
        }
        else
        {
            // Alert the user if the user left the fields blank
            println("Save failed.")
            var myAlert = UIAlertController()
            let alertController = UIAlertController(title: "Could not save item! ", message: "Sorry, please fill out all the fields!", preferredStyle: .Alert)
            
            
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
