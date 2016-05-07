//
//  NewsTableViewController.swift
//  NewsReader
//
//  Created by val on 22/04/2016.
//  Copyright © 2016 Qing. All rights reserved.
//

import UIKit

class NewsTableViewController: UITableViewController {
    
    //New
    var allNews: NSMutableArray
    var syncCompleted:Bool = false
    
    required init?(coder aDecoder: NSCoder) {
        self.allNews = NSMutableArray()
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Check whether network is available, if not put out an alert window
        if !Reachability.isConnectedToNetwork() {
            showAlertButtonTapped()
        } else {
            //If network is ok, load data from internet
            self.downloadNewsData()
            self.tableView.reloadData()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func downloadNewsData()
    {
        //Create json request
        let requestURL: NSURL = NSURL(string: "https://query.yahooapis.com/v1/public/yql?q=select%20*%20from%20feed%20where%20url=%27www.abc.net.au%2Fnews%2Ffeed%2F51120%2Frss.xml%27&format=json")!
        let urlRequest: NSMutableURLRequest = NSMutableURLRequest(URL: requestURL)
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(urlRequest) {
            (data, response, error) -> Void in
            //Get http response and if status is ok, read content of it
            let httpResponse = response as! NSHTTPURLResponse
            let statusCode = httpResponse.statusCode
            
            if (statusCode == 200) {
                
                do{
                    //Get news item one layer by one layer
                    let json = try NSJSONSerialization.JSONObjectWithData(data!, options:.AllowFragments)
                    let query = json.objectForKey("query") as! NSDictionary
                    let result = query.objectForKey("results") as! NSDictionary
                    let items = result.objectForKey("item") as! NSArray
                    //Duplicate title, description, link and image url from json response to self array
                    for news in (items as NSArray )
                    {
                        //Get title
                        let title = news["title"] as! String
                        //Dismiss useless chars at front and at last
                        let desc = news["description"] as! String
                        let newD = desc.substringFromIndex(desc.startIndex.advancedBy(33))
                        let newDesc = newD.substringToIndex(desc.endIndex.advancedBy(-33))
                        //Get link
                        let link = news["link"] as! String
                        //Get image url and check if no image exists, then set image url to null
                        var imageUrl = ""
                        if ((news["group"] as? NSDictionary) != nil) {
                            imageUrl = news["group"]!!["thumbnail"]!!["url"] as! String
                        }
                        //New a news with received data
                        let n = News(newTitle: title, newDesc: newDesc, newLink: link, newUrl: imageUrl)
                        //Add news into array
                        self.allNews.addObject(n)
                    }
                    print("done")
                }catch {
                    print("Error with Json: \(error)")
                }
                self.doTableRefresh()
            }
        }
        task.resume()
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        //Set cell identifier with the same as layout
        let cellIdentifier = "NewsCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! NewsCell
        
        // Configure the cell with title, description and image
        let n:News = allNews[indexPath.row] as! News
        cell.titleLabel.text = "\(n.title)"
        //Make label auto wripped
        cell.titleLabel.lineBreakMode = NSLineBreakMode.ByWordWrapping
        cell.titleLabel.numberOfLines = 0
        
        cell.descLabel.text = "\(n.desc)"
        //Make label auto wripped
        cell.descLabel.lineBreakMode = NSLineBreakMode.ByWordWrapping
        cell.descLabel.numberOfLines = 0
        
        //Set image from its url
        let url = NSURL(string: n.imageUrl)
        let data = NSData(contentsOfURL: url!) //make sure your image in this url does exist, otherwise unwrap in a if let check
        cell.imgView!.image = UIImage(data: data!)
        
        return cell
        
    }
    
    //Refresh table content
    func doTableRefresh()
    {
        dispatch_async(dispatch_get_main_queue(), {
            self.tableView.reloadData()
            return
        })
    }
    
    //Make an alert about network problem
    @IBAction func showAlertButtonTapped() {
        
        // create the alert
        let alert = UIAlertController(title: "Error", message: "No network..", preferredStyle: UIAlertControllerStyle.Alert)
        
        // add an action (button)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
        
        // show the alert
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    
    // MARK: - Table view data source
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.allNews.count
        
    }
    
    //Navigate to news view page with selected row
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if segue.identifier == "showDetail" {
            let viewController : ViewNewsDetail = segue.destinationViewController as! ViewNewsDetail
            //get link of news for selected row
            let index = self.tableView.indexPathForSelectedRow!.row
            let selectedN: News = self.allNews[index] as! News
            var url: String = selectedN.link as! String
            // get data by index and pass it to second view controller
            viewController.url = url
        }
    }
    
}
