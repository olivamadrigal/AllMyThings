//
//  ReportBugViewController.swift
//  AllMyThings
//
//  Created by Kareem Khattab on 3/28/15.
//  Copyright (c) 2015 Kareem Khattab. All rights reserved.
//

import UIKit

class ReportBugViewController: UIViewController, UITextFieldDelegate, UINavigationControllerDelegate, UITextViewDelegate {

    @IBOutlet weak var titleTxtField: UITextField!
    
    @IBOutlet weak var commentTxtView: UITextView!
    
    @IBOutlet weak var submitBtn: UIButton!
    
    @IBOutlet weak var staffTxtView: UITextView!
    
    
    @IBOutlet weak var usernameLbl: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //optimizing the report fields for all devices and custom attributes
        
        let theWidth = view.frame.size.width
        let theHeight = view.frame.size.height
        
        titleTxtField.center = CGPointMake(theWidth/2, 130)
        titleTxtField.layer.borderWidth = 0.5
        titleTxtField.layer.cornerRadius = 5
        titleTxtField.textColor = UIColor.lightGrayColor()
        
        commentTxtView.center = CGPointMake(theWidth/2, 230)
        submitBtn.center = CGPointMake(theWidth/2, 330)
        staffTxtView.center = CGPointMake(theWidth/2, theHeight - 30)

        
        // attributes for the noteTxtView
        commentTxtView.layer.borderColor = UIColor.blackColor().CGColor
        commentTxtView.layer.borderWidth = 0.5
        commentTxtView.layer.cornerRadius = 5
        commentTxtView.text = "Comments"
        commentTxtView.textColor = UIColor.lightGrayColor()
        self.commentTxtView.delegate = self
        // itemnameTxt field becoming the firsresponder and setting the delegate for the textfield functions
        titleTxtField.becomeFirstResponder()
        self.titleTxtField.delegate = self;
        
        usernameLbl.text = username
        
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
       titleTxtField.resignFirstResponder()
        
        
        
        
        return false
    }
    
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        
        self.view.endEditing(true)
    }
    
    
    func textViewDidEndEditing(textView: UITextView) {
        let theWidth = view.frame.size.width
        let theHeight = view.frame.size.height
        
        if(UIScreen.mainScreen().bounds.height == 568 || UIScreen.mainScreen().bounds.height == 667)
        {
            if(textView == commentTxtView)
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
            if(textView == commentTxtView)
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
    

    
    @IBAction func submitBugBtn(sender: AnyObject) {
       
        
         var reportAlert:UIAlertController = UIAlertController(title: "Report Submitted", message: "All Reports Are Reviewed By Our Staff", preferredStyle: UIAlertControllerStyle.Alert)
        
        
        var addReport = PFObject(className: "Report")
        addReport.setObject(usernameLbl.text, forKey: "Username")
        addReport.setObject(titleTxtField.text, forKey: "Issue")
        addReport.setObject(commentTxtView.text, forKey: "Comments")
        addReport.save()
        
        
        
        reportAlert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.Cancel, handler: nil))
        self.presentViewController(reportAlert, animated: true, completion: nil)

    }
    
    @IBAction func toggleSideMenu(sender: AnyObject) {
        toggleSideMenuView()
    }
}
