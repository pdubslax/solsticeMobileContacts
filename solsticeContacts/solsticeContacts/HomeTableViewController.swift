//
//  HomeTableViewController.swift
//  solsticeContacts
//
//  Created by Patrick Wilson on 2/12/16.
//  Copyright © 2016 Patrick Wilson. All rights reserved.
//

import UIKit

class HomeTableViewController: UITableViewController {

    
    
    var contactList:[Contact] = []
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.getJSONData()
        
        let nib = UINib(nibName: "MainTableViewCell", bundle: nil)
        
        self.tableView.registerNib(nib, forCellReuseIdentifier: "customCell")
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func getJSONData(){
        let requestURL: NSURL = NSURL(string: "https://solstice.applauncher.com/external/contacts.json")!
        let urlRequest: NSMutableURLRequest = NSMutableURLRequest(URL: requestURL)
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(urlRequest) {
            (data, response, error) -> Void in
            
            let httpResponse = response as! NSHTTPURLResponse
            let statusCode = httpResponse.statusCode
            
            if (statusCode == 200) {
                
                do{
                    
                    let json:NSArray = try NSJSONSerialization.JSONObjectWithData(data!, options:.AllowFragments) as! NSArray
                    for var i = 0; i<json.count; ++i {
                        let dictResult = json.objectAtIndex(i) as! NSDictionary
                        let newContact = Contact(birthdate: dictResult.objectForKey("birthdate") as! String, company: dictResult.objectForKey("company") as! String, detailsURL: dictResult.objectForKey("detailsURL") as! String, employeeID: dictResult.objectForKey("employeeId") as! NSNumber, name: dictResult.objectForKey("name") as! String, phone: dictResult.objectForKey("phone") as! NSMutableDictionary, smallImageURL: dictResult.objectForKey("smallImageURL") as! String)
                        self.contactList.append(newContact)
                    }
                    self.tableView.reloadData()
                    
                    
                    //                    if let stations = json["stations"] as? [[String: AnyObject]] {
                    //
                    //                        for station in stations {
                    //
                    //                            if let name = station["stationName"] as? String {
                    //
                    //                                if let year = station["buildYear"] as? String {
                    //                                    NSLog("%@ (Built %@)",name,year)
                    //                                }
                    //
                    //                            }
                    //                        }
                    //
                    //                    }
                    
                }catch {
                    print("Error with Json: \(error)")
                    
                }
                
            }
            
        }
        
        task.resume()
        
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
        return self.contactList.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
         let cell:MainTableViewCell = self.tableView.dequeueReusableCellWithIdentifier("customCell") as! MainTableViewCell

        // Configure the cell...
        cell.nameLabel?.text = self.contactList[indexPath.row].name
        
        
        cell.loadPictureAtURL(self.contactList[indexPath.row].smallImageURL)
        

        return cell
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 100;
        
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
