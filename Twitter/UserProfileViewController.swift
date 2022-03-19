//
//  UserProfileViewController.swift
//  Twitter
//
//  Created by Jibril Mohamed on 3/15/22.
//  Copyright © 2022 Dan. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage

class UserProfileViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var userProfile = [String: Any]()
    var tweetArray = [[String: Any]]()

    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var profileBanner: UIImageView!
    @IBOutlet weak var created_at: UILabel!
    @IBOutlet weak var username: UILabel!
    
    @IBOutlet weak var following_count: UILabel!
    @IBOutlet weak var followers_count: UILabel!
    
    @IBOutlet weak var profileName: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        let url = "https://api.twitter.com/1.1/account/verify_credentials.json"
        let params = [String: Any]()
        TwitterAPICaller.client?.userProfile(url: url, parameters: params, success: { [self] user in
            print("USER DATA::: \(user)")
            self.userProfile = user as! [String:Any]
            
            let name = self.userProfile["name"] as? String
            let createdAt = userProfile["created_at"] as? String
            let following = (userProfile["friends_count"] as! NSNumber).stringValue
            let followers_cnt = (userProfile["followers_count"] as! NSNumber).stringValue
            let profile_banner_url = URL(string: userProfile["profile_banner_url"] as! String)
            let profile_image_url = URL(string: userProfile["profile_image_url"] as! String)
            let screen_name = userProfile["screen_name"] as? String
            
            following_count?.text = following
            followers_count?.text = followers_cnt
           
            profileImage.af_setImage(withURL: profile_image_url!)
            profileBanner.af_setImage(withURL: profile_banner_url!)
            
            profileImage.layer.cornerRadius = profileImage.frame.size.width / 2
            profileImage.clipsToBounds = true
            
            profileName?.text = name
            username?.text = screen_name
            created_at?.text = createdAt
            
        }, failure: { Error in
            print("Error Occurred:: \(Error)")
        })
        
        
           let Parenturl = "https://api.twitter.com/1.1/statuses/user_timeline.json"
           let Parentparams = [String: Any]()
           TwitterAPICaller.client?.getDictionariesRequest(url: Parenturl, parameters: Parentparams, success: { (tweets: [NSDictionary]) in
               self.tweetArray.removeAll()
               for tweet in tweets {
                   self.tweetArray.append(tweet as! [String : Any])
               }
               self.tableView.reloadData()
           }, failure: { Error in
               print("Error in Rendering user Tweets \(Error)")
           })
           
    
        
        tableView.delegate = self
        tableView.dataSource = self

        // Do any additional setup after loading the view.
    }
    
    @IBAction func segmentedControl(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            print("Tweets selected!")
            let params = [String: Any]()
            let url = "https://api.twitter.com/1.1/statuses/user_timeline.json"
            TwitterAPICaller.client?.getDictionariesRequest(url: url, parameters: params, success: { (tweets: [NSDictionary]) in
                self.tweetArray.removeAll()
                for tweet in tweets {
                    self.tweetArray.append(tweet as! [String : Any])
                }
                self.tableView.reloadData()
            }, failure: { Error in
                print("Error in Rendering user Tweets \(Error)")
            })
        case 1:
            print("Tweets&Media selected")
            let url = "https://api.twitter.com/1.1/statuses/home_timeline.json"
            let params = [String: Any]()
            TwitterAPICaller.client?.getDictionariesRequest(url: url, parameters: params, success: { (tweets: [NSDictionary]) in
                self.tweetArray.removeAll()
                for tweet in tweets {
                    self.tweetArray.append(tweet as! [String : Any])
                }
                self.tableView.reloadData()
            }, failure: { Error in
                print("Error in Rendering user Tweets \(Error)")
            })
            print("Tweets::::: \(tweetArray)")
        case 2:
            print("Media selected")
        case 3:
            print("Likes selected")
            let url = "https://api.twitter.com/1.1/favorites/list.json"
            let params = [String: Any]()
            TwitterAPICaller.client?.getDictionariesRequest(url: url, parameters: params, success: { (tweets: [NSDictionary]) in
                self.tweetArray.removeAll()
                for tweet in tweets {
                    self.tweetArray.append(tweet as! [String : Any])
                }
                self.tableView.reloadData()
            }, failure: { Error in
                print("Error in Rendering user Tweets \(Error)")
            })
        default:
            print("Default case")
            let url = "https://api.twitter.com/1.1/statuses/home_timeline.json"
            let params = [String: Any]()
            TwitterAPICaller.client?.getDictionariesRequest(url: url, parameters: params, success: { (tweets: [NSDictionary]) in
                self.tweetArray.removeAll()
                for tweet in tweets {
                    self.tweetArray.append(tweet as! [String : Any])
                }
                self.tableView.reloadData()
            }, failure: { Error in
                print("Error in Rendering user Tweets \(Error)")
            })
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tweetArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TweetCell") as! TweetCell
        let tweet = self.tweetArray[indexPath.row]
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
