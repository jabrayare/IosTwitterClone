//
//  TweetCell.swift
//  Twitter
//
//  Created by Jibril Mohamed on 3/11/22.
//  Copyright © 2022 Dan. All rights reserved.
//

import UIKit

class TweetCell: UITableViewCell {

    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var userTweetContent: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    
    @IBOutlet weak var replayCount: UILabel!
    @IBOutlet weak var likesCount: UILabel!
    @IBOutlet weak var retweetCount: UILabel!
    @IBOutlet weak var screenName: UILabel!
    
    @IBOutlet weak var favButton: UIButton!
   
    @IBOutlet weak var retweetButton: UIButton!
    
    var favorite: Bool = false
    var tweetId: Int = -1
    var retweeted: Bool = false
    
    func setFavorite(_ isfavorite: Bool){
        if (isfavorite) {
            favButton.setImage(UIImage(named: "favor-icon-red"), for: UIControl.State.normal)
        }
        else {
            favButton.setImage(UIImage(named: "favor-icon"), for: UIControl.State.normal)
        }
    }
    
    func setRetweeted(_ isRetweeted: Bool){
        if (isRetweeted) {
            retweetButton.setImage(UIImage(named: "retweet-icon-green"), for: UIControl.State.normal)
        }
        else {
            retweetButton.setImage(UIImage(named: "retweet-icon"), for: UIControl.State.normal)
        }
    }
    
    @IBAction func favoriteTweet(_ sender: Any) {
        print("Button clicked")
        if(!favorite) {
            TwitterAPICaller.client?.favoriteTweet(tweetId: tweetId, success: {
                self.setFavorite(true)
            }, failure: { Error in
                print("Error Favoriting::: \(Error)")
            })
        }
        else {
            TwitterAPICaller.client?.unFavoriteTweet(tweetId: tweetId, success: {
                self.setFavorite(false)
            }, failure: { Error in
                print("Favorite Failed::: \(Error)")
            })
        }
        self.favorite = !self.favorite
    }
    
    
    @IBAction func retweet(_ sender: Any) {
        
        print("Retweet Button clicked!!!")
        if(!retweeted) {
            TwitterAPICaller.client?.retweet(tweetId: tweetId, success: {
                self.setRetweeted(true)
                self.retweeted = true
                print("Just retweeted!!")
            }, failure: { Error in
                print("Failed to retweet")
            })
            
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
