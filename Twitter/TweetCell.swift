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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
