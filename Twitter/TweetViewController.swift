//
//  TweetViewController.swift
//  Twitter
//
//  Created by Jibril Mohamed on 3/12/22.
//  Copyright © 2022 Dan. All rights reserved.
//

import UIKit

class TweetViewController: UIViewController, UITextViewDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var textCount: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textView.delegate = self
        textView.becomeFirstResponder()
        
        let color = UIColor.black
        textView.layer.borderColor = color.cgColor
        textView.layer.borderWidth = 1.0
        textView.layer.cornerRadius = 12.0

        // Do any additional setup after loading the view.
    }
    override func viewDidDisappear(_ animated: Bool) {
        self.dismiss(animated: true, completion: nil)
        
    }
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        // Set the max character limit
        let characterLimit = 140

        // Construct what the new text would be if we allowed the user's latest edit
        let newText = NSString(string: textView.text!).replacingCharacters(in: range, with: text)

        // TODO: Update Character Count Label

        // The new text should be allowed? True/False
        let characterRemaining = characterLimit - newText.count
        textCount?.text = String(characterRemaining)
        if characterRemaining < 20 {
            textCount.textColor = UIColor.systemRed
        }
        else {
            textCount.textColor = UIColor.black
        }
        return newText.count < characterLimit
    }
    
    @IBAction func cancelButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func tweetButton(_ sender: Any) {
        let tweetText = textView?.text
        if (!tweetText!.isEmpty){
            TwitterAPICaller.client?.postTweet(tweetString: tweetText!, success: {
                print("Tweet posted!")
            }, failure: { Error in
                print("Error detected::: \(Error)")
            })
        }
        self.dismiss(animated: true, completion: nil)
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
