//
//  DetailTableViewController.swift
//  solsticeContacts
//
//  Created by Patrick Wilson on 2/13/16.
//  Copyright © 2016 Patrick Wilson. All rights reserved.
//

import UIKit

class DetailTableViewController: UITableViewController {

    var contact : Contact = Contact.init()
    var contactDetailObject : ContactDetail = ContactDetail.init()
    var isFavorited : Bool = true
    var bigImage : UIImage = UIImage()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        UIButton *settingsView = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 61, 30)];
//        [settingsView addTarget:self action:@selector(SettingsClicked) forControlEvents:UIControlEventTouchUpInside];
//        [settingsView setBackgroundImage:[UIImage imageNamed:@"settings"] forState:UIControlStateNormal];
//        UIBarButtonItem *settingsButton = [[UIBarButtonItem alloc] initWithCustomView:settingsView];
//        [self.navigationItem setRightBarButtonItem:settingsButton];
        
        let testButton : UIButton = UIButton.init(frame: CGRectMake(0, 0, 30, 30))
        testButton.setBackgroundImage(UIImage(named:"edit"), forState: UIControlState.Normal)
        let editButton : UIBarButtonItem = UIBarButtonItem.init(customView: testButton)
        
        let testButton2 : UIButton = UIButton.init(frame: CGRectMake(0, 0, 30, 30))
        testButton2.setBackgroundImage(UIImage(named:"star"), forState: UIControlState.Normal)
        testButton2.addTarget(self, action: "favorite", forControlEvents: UIControlEvents.TouchUpInside)
        let starButton : UIBarButtonItem = UIBarButtonItem.init(customView: testButton2)
      
       
        self.navigationItem.rightBarButtonItems = [editButton,starButton]
        
        self.getJSONDataForDetails()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    func favorite(){
        let testButton : UIButton = UIButton.init(frame: CGRectMake(0, 0, 30, 30))
        testButton.setBackgroundImage(UIImage(named:"edit"), forState: UIControlState.Normal)
        let editButton : UIBarButtonItem = UIBarButtonItem.init(customView: testButton)
        
        let testButton2 : UIButton = UIButton.init(frame: CGRectMake(0, 0, 30, 30))
        if self.isFavorited{
            testButton2.setBackgroundImage(UIImage(named:"fillStar"), forState: UIControlState.Normal)
            self.isFavorited = false
        }else{
            testButton2.setBackgroundImage(UIImage(named:"star"), forState: UIControlState.Normal)
            self.isFavorited = true
        }
        testButton2.addTarget(self, action: "favorite", forControlEvents: UIControlEvents.TouchUpInside)
        let starButton : UIBarButtonItem = UIBarButtonItem.init(customView: testButton2)
        
        
        self.navigationItem.rightBarButtonItems = [editButton,starButton]
    }
    
    func getJSONDataForDetails(){
        let requestURL: NSURL = NSURL(string: self.contact.detailsURL)!
        let urlRequest: NSMutableURLRequest = NSMutableURLRequest(URL: requestURL)
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(urlRequest) {
            (data, response, error) -> Void in
            
            let httpResponse = response as! NSHTTPURLResponse
            let statusCode = httpResponse.statusCode
            
            if (statusCode == 200) {
                
                do{
                    
                    let dictResult:NSDictionary = try NSJSONSerialization.JSONObjectWithData(data!, options:.AllowFragments) as! NSDictionary
                    let newContactDetail = ContactDetail(employeeID: dictResult.objectForKey("employeeId") as! NSNumber, favorite: dictResult.objectForKey("favorite") as! Bool, largeImageURL: dictResult.objectForKey("largeImageURL") as! String, email: dictResult.objectForKey("email") as! String, website: dictResult.objectForKey("website") as! String, address: dictResult.objectForKey("address") as! NSMutableDictionary)
                        
                    self.contactDetailObject = newContactDetail
                    self.downloadImage(NSURL(string: newContactDetail.largeImageURL)!)
                    
                    self.tableView.reloadData()
                    
                    
                }catch {
                    print("Error with Json: \(error)")
                    
                }
                
            }
            
        }
        
        task.resume()
        
    }
    
    func downloadImage(url: NSURL) {
        
        getDataFromUrl(url) { (data, response, error)  in
            dispatch_async(dispatch_get_main_queue()) { () -> Void in
                guard let data = data where error == nil else { return }
                let newImage = UIImage(data: data)
                self.bigImage = newImage!
                self.tableView.reloadData()
                
            }
        }
    }
    
    func getDataFromUrl(url:NSURL, completion: ((data: NSData?, response: NSURLResponse?, error: NSError? ) -> Void)) {
        NSURLSession.sharedSession().dataTaskWithURL(url) { (data, response, error) in
            completion(data: data, response: response, error: error)
            }.resume()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("nameDetailViewCell")! as! NameDetailTableViewCell
        cell.nameLabel.text = self.contact.name
        cell.companyLabel.text = self.contact.company
        cell.bigImageView?.image = self.bigImage

        return cell
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 120;
        
    }


    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
