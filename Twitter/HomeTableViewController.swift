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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.loadTweets()
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
    
 
    @IBAction func tweetButton(_ sender: Any) {
        self.performSegue(withIdentifier: "tweetBtnToTweetViewController", sender: nil)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TweetCell", for: indexPath) as! TweetCell
        
        let tweet = tweetArray[indexPath.row]
  
        let user = tweet["user"] as! NSDictionary
        let name = user["name"] as? String
        let screenName = user["screen_name"] as? String
        let tweetPost = tweet["text"] as? String
        let profileImageURL = URL(string: user["profile_image_url"] as! String)!
        
        let favCount = ((tweet["favorite_count"]  ?? 0) as! NSNumber).stringValue
        let replayCount = ((tweet["replay_count"] ?? 0) as! NSNumber).stringValue
        let retCount = ((tweet["retweet_count"] ?? 0) as! NSNumber).stringValue
        
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
        
        cell.setFavorite(tweet["favorited"] as! Bool)
        cell.retweeted = tweet["retweeted"] as! Bool 
        cell.tweetId = tweet["id"] as! Int
        
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
}
