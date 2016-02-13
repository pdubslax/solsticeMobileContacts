//
//  DetailTableViewController.swift
//  solsticeContacts
//
//  Created by Patrick Wilson on 2/13/16.
//  Copyright © 2016 Patrick Wilson. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class DetailTableViewController: UITableViewController {

    var contact : Contact = Contact.init()
    var contactDetailObject : ContactDetail = ContactDetail.init()
    var bigImage : UIImage = UIImage()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.getJSONDataForDetails()
        
        self.favorite()
        
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.None

    }
    
    func favorite(){
        let testButton : UIButton = UIButton.init(frame: CGRectMake(0, 0, 25, 25))
        testButton.setBackgroundImage(UIImage(named:"edit"), forState: UIControlState.Normal)
        let editButton : UIBarButtonItem = UIBarButtonItem.init(customView: testButton)
        
        let testButton2 : UIButton = UIButton.init(frame: CGRectMake(0, 0, 25, 25))
        if self.contactDetailObject.favorite{
            testButton2.setBackgroundImage(UIImage(named:"fillStar"), forState: UIControlState.Normal)
            self.contactDetailObject.favorite = false
        }else{
            testButton2.setBackgroundImage(UIImage(named:"star"), forState: UIControlState.Normal)
            self.contactDetailObject.favorite = true
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
        return 3
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if section==0{
            return 1
        }else if section == 1{
            return 3
        }else if section == 2{
            return 1
        }
        return 0
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.section==0{
            let cell = tableView.dequeueReusableCellWithIdentifier("nameDetailViewCell")! as! NameDetailTableViewCell
            cell.nameLabel.text = self.contact.name
            cell.companyLabel.text = self.contact.company
            cell.bigImageView?.image = self.bigImage
        
            return cell
        }
        else if indexPath.section==1{
            let phoneOrder = ["work","home","mobile"]
            
            let cell = tableView.dequeueReusableCellWithIdentifier("phoneListingCell")!
            var titleWord = phoneOrder[indexPath.row] 
            titleWord.replaceRange(titleWord.startIndex...titleWord.startIndex, with: String(titleWord[titleWord.startIndex]).capitalizedString)

            cell.detailTextLabel?.text = titleWord
            cell.textLabel?.text = self.contact.phone.objectForKey(phoneOrder[indexPath.row]) as? String
            return cell
        }
        else if indexPath.section==2{
            let cell = tableView.dequeueReusableCellWithIdentifier("phoneListingCell")!
            cell.textLabel?.numberOfLines = 2
            
            cell.detailTextLabel?.text = ""
            cell.textLabel?.text = (self.contactDetailObject.address.objectForKey("street") as? String)! + " \n" + (self.contactDetailObject.address.objectForKey("city") as? String)! + ", " + (self.contactDetailObject.address.objectForKey("state") as? String)! + " " + (self.contactDetailObject.address.objectForKey("zip") as? String)!
            
            return cell
        }
        else{
            let cell = tableView.dequeueReusableCellWithIdentifier("phoneListingCell")!
            return cell
        }
        
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.section==0{
            return 120.0
        }else if indexPath.section==1{
            return 35.0
        }else if indexPath.section==2{
            return 60.0
        }else{
            return 40.0
        }
        
    }
    
    override func tableView(tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int)
    {
        let header = view as! UITableViewHeaderFooterView
        header.contentView.backgroundColor = UIColor.whiteColor()
        if section == 1{
            header.textLabel?.text = "Phone:"
        }
        else if section == 2{
            header.textLabel?.text = "Address:"
        }
        header.textLabel?.font = UIFont(name: "AvenirNext-Medium", size: 18)!
    }
    
    override func tableView(tableView: UITableView, willDisplayFooterView view: UIView, forSection section: Int)
    {
        let footer = view as! UITableViewHeaderFooterView
        footer.contentView.backgroundColor = UIColor.whiteColor()
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 0 ? 0.0 : 20.0
    }
    
    override func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 30.0
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
        if indexPath.section == 1{
            let phoneOrder = ["work","home","mobile"]
            let number = self.contact.phone.objectForKey(phoneOrder[indexPath.row]) as? String
            let cleanedNumber = number!.stringByReplacingOccurrencesOfString("-", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil)
            if cleanedNumber.characters.count > 0{
                UIApplication.sharedApplication().openURL(NSURL(string: "tel://" + cleanedNumber)!)
            }
        }else if indexPath.section == 2{
            let lat1 : NSString = (self.contactDetailObject.address.objectForKey("latitude") as? NSNumber)!.stringValue
            let lng1 : NSString = (self.contactDetailObject.address.objectForKey("longitude") as? NSNumber)!.stringValue
            
            let latitute :CLLocationDegrees =  lat1.doubleValue
            let longitute:CLLocationDegrees =  lng1.doubleValue
            
            let regionDistance:CLLocationDistance = 10000
            let coordinates = CLLocationCoordinate2DMake(latitute, longitute)
            let regionSpan = MKCoordinateRegionMakeWithDistance(coordinates, regionDistance, regionDistance)
            let options = [
                MKLaunchOptionsMapCenterKey: NSValue(MKCoordinate: regionSpan.center),
                MKLaunchOptionsMapSpanKey: NSValue(MKCoordinateSpan: regionSpan.span)
            ]
            let placemark = MKPlacemark(coordinate: coordinates, addressDictionary: nil)
            let mapItem = MKMapItem(placemark: placemark)
            mapItem.name = self.contact.name
            mapItem.openInMapsWithLaunchOptions(options)
        
        }
        
        
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
