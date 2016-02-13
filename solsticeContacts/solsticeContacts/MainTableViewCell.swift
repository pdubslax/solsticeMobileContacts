//
//  MainTableViewCell.swift
//  solsticeContacts
//
//  Created by Patrick Wilson on 2/12/16.
//  Copyright © 2016 Patrick Wilson. All rights reserved.
//

import UIKit

class MainTableViewCell: UITableViewCell {
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var mainImageView: UIImageView!
    
    var imageDownloaded: Bool!
    var contactImage: UIImage!
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        self.imageDownloaded = false
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func loadPictureAtURL(url: String){
        self.mainImageView.contentMode = .ScaleAspectFit
//        downloadImage(NSURL(string: url)!)
        if self.imageDownloaded == false{
            downloadImage(NSURL(string: url)!)
        }else{
            self.mainImageView.image = self.contactImage
        }
    }
    
    func downloadImage(url: NSURL){
        print("Download Started")
        print("lastPathComponent: " + (url.lastPathComponent ?? ""))
        getDataFromUrl(url) { (data, response, error)  in
            dispatch_async(dispatch_get_main_queue()) { () -> Void in
                guard let data = data where error == nil else { return }
                print(response?.suggestedFilename ?? "")
                print("Download Finished")
                self.mainImageView.image = UIImage(data: data)
                self.contactImage = UIImage(data: data)
                self.imageDownloaded = true
            }
        }
    }
    
    func getDataFromUrl(url:NSURL, completion: ((data: NSData?, response: NSURLResponse?, error: NSError? ) -> Void)) {
        NSURLSession.sharedSession().dataTaskWithURL(url) { (data, response, error) in
            completion(data: data, response: response, error: error)
            }.resume()
    }
    
    
    
}
