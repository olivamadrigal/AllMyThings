//
//  LegalViewController.swift
//  AllMyThings
//
//  Created by Kareem Khattab on 3/28/15.
//  Copyright (c) 2015 Kareem Khattab. All rights reserved.
//

import UIKit

class LegalViewController: UIViewController, UINavigationControllerDelegate {

    @IBOutlet weak var legalTextView: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
       legalTextView.scrollEnabled = true
        var attributes = [
            NSForegroundColorAttributeName: UIColor.whiteColor(),
            NSFontAttributeName: UIFont(name: "HelveticaNeue", size: 18)!
        ]
        self.navigationController?.navigationBar.titleTextAttributes = attributes
        self.navigationController?.navigationBar.barTintColor = UIColor.grayColor()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
   
   


}
