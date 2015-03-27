//
//  HomeVC.swift
//  AllMyThings
//
//  Created by Kareem Khattab on 3/24/15.
//  Copyright (c) 2015 Kareem Khattab. All rights reserved.
//

import UIKit

var username = ""
var listName = ""

class HomeVC: UITableViewController, UINavigationControllerDelegate  {

    // this is our list object
    var usersLists = [PFObject]()
    
    
    // this is for our pull to refresh functions
    var refreshLoadingView : UIView!
    var refreshColorView : UIView!
    var compass_background : UIImageView!
    var compass_spinner : UIImageView!
    
    var isRefreshIconsOverlap = false
    var isRefreshAnimating = false

    
    
    
     @IBOutlet weak var listTable: UITableView!
    
    
    // create list will  segue to the home screen when the user hits the cancel button 
    @IBAction func cancelToHomeViewController(segue:UIStoryboardSegue) {
        
        dismissViewControllerAnimated(true, completion: nil)
        println("Back to List")
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
    override func viewDidLoad() {
        super.viewDidLoad()
    
    
       self.loadData()
        // Set up the refresh control
        self.setupRefreshControl()
    
        let theWidth = view.frame.size.width
        let theHeight = view.frame.size.height
        //Optimizing the table view for all devices
        listTable.frame = CGRectMake(0, 0, theWidth, theHeight - 64)
        // navigation bar attributes 
        var attributes = [
            NSForegroundColorAttributeName: UIColor.whiteColor(),
            NSFontAttributeName: UIFont(name: "HelveticaNeue", size: 18)!
        ]
        self.navigationController?.navigationBar.titleTextAttributes = attributes
        self.navigationController?.navigationBar.barTintColor = UIColor.grayColor()
        
    
        username = PFUser.currentUser().username
        
     
    }
    
    override func viewWillAppear(animated: Bool) {
        
        self.loadData()
        //hides back button
        self.navigationItem.hidesBackButton = true
        //shows the navigation bar
        self.navigationController?.navigationBarHidden = false
        
        
    }

    
    func loadData(){
        usersLists.removeAll(keepCapacity: false)
        //only query the lists that belong to the currently signed in user
        let predicate = NSPredicate(format: "Username == '"+username+"'")
        var findListData:PFQuery = PFQuery(className:"List", predicate: predicate)
        findListData.findObjectsInBackgroundWithBlock
            {
                (objects:[AnyObject]! , error:NSError!) -> Void in
                if error == nil
                {
                    self.usersLists = objects.reverse() as [PFObject]
                    
                    self.tableView.reloadData()
                }
        }
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        return usersLists.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as HomeTableCell

        // Configure the cell...
        let list: PFObject = self.usersLists[indexPath.row] as PFObject
        cell.nameTxtField.text = list.objectForKey("Name") as String
        cell.typeTxtField.text = list.objectForKey("Type") as String
        
        // the date in which the user created the list 
        var dataFormatter:NSDateFormatter = NSDateFormatter()
        dataFormatter.dateFormat = "MM/dd/yyyy"
        cell.timeStampLbl.text = dataFormatter.stringFromDate(list.createdAt)
        
        
        // stop user from changing the lists
        cell.nameTxtField.userInteractionEnabled = false
        cell.typeTxtField.userInteractionEnabled = false
        cell.usernameLbl.userInteractionEnabled =  false
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        var cell = tableView.cellForRowAtIndexPath(indexPath) as HomeTableCell
        listName = cell.nameTxtField.text
        println("Cell clicked")
        //when the cell is clicked segue to that lists view controller
        self.performSegueWithIdentifier("goToList", sender: self)
        
    }
    
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        
        if (editingStyle == UITableViewCellEditingStyle.Delete)
        {
            
            
            //the list to remove at that table cell
            var listToRemove = self.usersLists[indexPath.row] as PFObject
            // delete the list object
            listToRemove.deleteInBackgroundWithTarget(self, selector: nil)
            // save it to the current user
            PFUser.currentUser().save()
            // delete the cell of the list you addded
            usersLists.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Fade)
            tableView.reloadData()
            
            
            
        }
    }
    
 

    

}
