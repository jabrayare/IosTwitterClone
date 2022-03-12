//
//  HomeTableViewController.swift
//  Twitter
//
//  Created by Jibril Mohamed on 3/11/22.
//  Copyright © 2022 Dan. All rights reserved.
//

import UIKit
import AlamofireImage
import Alamofire

class HomeTableViewController: UITableViewController {
    var tweetArray = [[String: Any]]()
    var numberOfTweets: Int!
    let tweetURL = "https://api.twitter.com/1.1/statuses/home_timeline.json"
    
    let myRefreshControl = UIRefreshControl()
  
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        self.loadTweets()
        
        myRefreshControl.addTarget(self, action: #selector(loadTweets), for: .valueChanged)
        
        tableView.refreshControl = myRefreshControl
        
    }

    
    @objc func loadTweets() {
        numberOfTweets = 20
        let params = ["count": numberOfTweets]
        TwitterAPICaller.client?.getDictionariesRequest(url: tweetURL, parameters: params as [String : Any], success: { (tweets: [NSDictionary]) in
            self.tweetArray.removeAll()
            for tweet in tweets {
                self.tweetArray.append(tweet as! [String : Any])
            }
            self.tableView.reloadData()
            self.myRefreshControl.endRefreshing()
        }, failure: { Error in
            print("Getting Tweets Failed!")
        })
    }
    
    func loadMoreTweets() {
        self.numberOfTweets += 20
        let params = ["count": numberOfTweets]
        TwitterAPICaller.client?.getDictionariesRequest(url: tweetURL, parameters: params as [String : Any], success: { (tweets: [NSDictionary]) in
            self.tweetArray.removeAll()
            for tweet in tweets {
                self.tweetArray.append(tweet as! [String : Any])
            }
            self.tableView.reloadData()
            self.myRefreshControl.endRefreshing()
        }, failure: { Error in
            print("Getting Tweets Failed!")
        })
        
    }
    
    
    @IBAction func onLogout(_ sender: Any) {
        TwitterAPICaller.client?.logout()
        self.dismiss(animated: true, completion: nil)
        UserDefaults.standard.set(false, forKey: "userLoggedIn")
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TweetCell", for: indexPath) as! TweetCell
        
        let tweet = tweetArray[indexPath.row]
        print("Tweet::: \(tweet)")
        let user = tweet["user"] as! NSDictionary
        let name = user["name"] as? String
        let screenName = user["screen_name"] as? String
        let tweetPost = tweet["text"] as? String
        let profileImageURL = URL(string: user["profile_image_url"] as! String)!
        
        let favCount = ((tweet["favorite_count"]  ?? 0) as! NSNumber).stringValue
        let replayCount = ((tweet["replay_count"] ?? 0) as! NSNumber).stringValue
        let retCount = ((tweet["retweet_count"] ?? 0) as! NSNumber).stringValue
        print("SCREEN NAME::: \(user["screen_name"])")
        cell.username?.text = name
        cell.userTweetContent?.text = tweetPost
        cell.profileImageView.af_setImage(withURL: profileImageURL)
        cell.screenName?.text = "@"+screenName!
        
        cell.replayCount?.text = replayCount
        cell.retweetCount?.text = retCount
        cell.likesCount?.text = favCount
        
        // Circle the profile image
        cell.profileImageView.layer.cornerRadius = cell.profileImageView.frame.size.width / 2
        cell.profileImageView.clipsToBounds = true
        
        return cell
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.tweetArray.count
    }
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row + 1 == tweetArray.count {
            loadMoreTweets()
        }
    }

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
