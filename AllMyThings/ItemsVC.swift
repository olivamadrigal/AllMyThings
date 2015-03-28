//
//  ItemsVC.swift
//  AllMyThings
//
//  Created by Kareem Khattab on 3/25/15.
//  Copyright (c) 2015 Kareem Khattab. All rights reserved.
//

import UIKit

class ItemsVC: UITableViewController {

     var itemData = [PFObject]()
    
    
    // this is for our pull to refresh functions
    var refreshLoadingView : UIView!
    var refreshColorView : UIView!
    var compass_background : UIImageView!
    var compass_spinner : UIImageView!
    
    var isRefreshIconsOverlap = false
    var isRefreshAnimating = false
    
    @IBAction func cancelToItemViewController(segue:UIStoryboardSegue) {
        
        dismissViewControllerAnimated(true, completion: nil)
        println("Back to Items")
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        
        // Set up the refresh control
        self.setupRefreshControl()

        
        self.loadData()
        
        
 
    }
    
    
    func setupRefreshControl() {
        
        // Programmatically inserting a UIRefreshControl
        self.refreshControl = UIRefreshControl()
        
        // Setup the loading view, which will hold the moving graphics
        self.refreshLoadingView = UIView(frame: self.refreshControl!.bounds)
        self.refreshLoadingView.backgroundColor = UIColor.clearColor()
        
        // Setup the color view, which will display the rainbowed background
        self.refreshColorView = UIView(frame: self.refreshControl!.bounds)
        self.refreshColorView.backgroundColor = UIColor.clearColor()
        self.refreshColorView.alpha = 0.30
        
        // Clip so the graphics don't stick out
        self.refreshLoadingView.clipsToBounds = true;
        
        // Hide the original spinner icon
        self.refreshControl!.tintColor = UIColor.grayColor()
        
        // Add the loading and colors views to our refresh control
        self.refreshControl!.addSubview(self.refreshColorView)
        self.refreshControl!.addSubview(self.refreshLoadingView)
        
        // Initalize flags
        self.isRefreshIconsOverlap = false;
        self.isRefreshAnimating = false;
        
        // When activated, invoke our refresh function
        self.refreshControl?.addTarget(self, action: "refresh", forControlEvents: UIControlEvents.ValueChanged)
    }
    
    
    func refresh(){
        
        self.loadData()
        
        // -- DO SOMETHING AWESOME (... or just wait 3 seconds) --
        // This is where you'll make requests to an API, reload data, or process information
        var delayInSeconds = 3.0;
        var popTime = dispatch_time(DISPATCH_TIME_NOW, Int64(delayInSeconds * Double(NSEC_PER_SEC)));
        dispatch_after(popTime, dispatch_get_main_queue()) { () -> Void in
            // When done requesting/reloading/processing invoke endRefreshing, to close the control
            self.refreshControl!.endRefreshing()
        }
        // -- FINISHED SOMETHING AWESOME, WOO! --
    }
    
    override func scrollViewDidScroll(scrollView: UIScrollView) {
        
        // Get the current size of the refresh controller
        var refreshBounds = self.refreshControl!.bounds;
        
        // Distance the table has been pulled >= 0
        var pullDistance = max(0.0, -self.refreshControl!.frame.origin.y);
        
        // Half the width of the table
        var midX = self.tableView.frame.size.width / 2.0;
        
        
        // Calculate the pull ratio, between 0.0-1.0
        var pullRatio = min( max(pullDistance, 0.0), 100.0) / 100.0;
        // Set the encompassing view's frames
        refreshBounds.size.height = pullDistance;
        
        self.refreshColorView.frame = refreshBounds;
        self.refreshLoadingView.frame = refreshBounds;
        
        // If we're refreshing and the animation is not playing, then play the animation
        if (self.refreshControl!.refreshing && !self.isRefreshAnimating) {
            self.animateRefreshView()
        }
        
    }
    
    func animateRefreshView() {
        
        // Background color to loop through for our color view
        
        var colorArray = [UIColor.whiteColor()]
        
        // In Swift, static variables must be members of a struct or class
        struct ColorIndex {
            static var colorIndex = 0
        }
        
        // Flag that we are animating
        self.isRefreshAnimating = true;
        
        UIView.animateWithDuration(
            Double(0.3),
            delay: Double(0.0),
            options: UIViewAnimationOptions.CurveLinear,
            animations: {
                // Change the background color
                self.refreshColorView!.backgroundColor = colorArray[ColorIndex.colorIndex]
                ColorIndex.colorIndex = (ColorIndex.colorIndex + 1) % colorArray.count
            },
            completion: { finished in
                // If still refreshing, keep spinning, else reset
                if (self.refreshControl!.refreshing) {
                    self.animateRefreshView()
                }else {
                    self.resetAnimation()
                }
            }
        )
    }
    
    func resetAnimation() {
        
        // Reset our flags and }background color
        self.isRefreshAnimating = false;
        self.isRefreshIconsOverlap = false;
        self.refreshColorView.backgroundColor = UIColor.clearColor()
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func loadData(){
        itemData.removeAll(keepCapacity: false)
        
        let predicate = NSPredicate(format: "List = %@ AND Username = %@ ", listName, username)

        //let predicate = NSPredicate(format: "List == '"+listName+"'")
        var findItemData:PFQuery = PFQuery(className:"Items", predicate: predicate)
        findItemData.findObjectsInBackgroundWithBlock
            {
                (objects:[AnyObject]! , error:NSError!) -> Void in
                if error == nil
                {
                    self.itemData = objects.reverse() as [PFObject]
                    self.tableView.reloadData()
                }
        }
    }

    
    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
        
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return itemData.count
        
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ItemCell", forIndexPath: indexPath) as ItemCell

    
        let item: PFObject = self.itemData[indexPath.row] as PFObject
        cell.itemNameTxtField.text = item.objectForKey("Name") as String
        cell.itemNoteTextField.text = item.objectForKey("Notes") as String
        // the list name from the home screen you clicked
        cell.listNameLbl.text = item.objectForKey("List") as? String
        // stops the user from editing the saved cell components
        cell.itemNameTxtField.userInteractionEnabled = false
        cell.itemNoteTextField.userInteractionEnabled = false
        cell.itemPicture.userInteractionEnabled = false
        cell.listNameLbl.userInteractionEnabled = false
        //Item Image
        if let profileImage = itemData[indexPath.row]["Image"] as? PFFile {
            profileImage.getDataInBackgroundWithBlock{
                (imageData:NSData! , error:NSError!)-> Void in
                
                if(error == nil) {
                    if imageData != nil{
                        let image:UIImage = UIImage (data: imageData)!
                        cell.itemPicture.image = image
                    }
                }
                
            }
            
        }
        
        

        return cell
    }

    

    
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
       
        if (editingStyle == UITableViewCellEditingStyle.Delete)
        {
            
            
            //the list to remove at that table cell
            var itemToRemove = self.itemData[indexPath.row] as PFObject
            // delete the list object
            itemToRemove.deleteInBackgroundWithTarget(self, selector: nil)
            // save it to the current user
            PFUser.currentUser().save()
            // delete the cell of the list you addded
            itemData.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Fade)
            tableView.reloadData()
            
            
            
        }

    
    }

}