//
//  FeedViewController.swift
//  Parstagram
//
//  Created by Jacob Ortiz on 10/17/20.
//  Copyright © 2020 jacobortiz. All rights reserved.
//

import UIKit
import Parse
import AlamofireImage
import MessageInputBar

class FeedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, MessageInputBarDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    let comment_bar = MessageInputBar()
    var shows_comment_bar = false
    var posts = [PFObject]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        comment_bar.inputTextView.placeholder = "Add a comment..."
        comment_bar.sendButton.title = "Post"
        comment_bar.delegate = self
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.keyboardDismissMode = .interactive
        
        let center = NotificationCenter.default
        center.addObserver(self, selector: #selector(keyboardWillBeHidden(note:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillBeHidden(note: Notification) {
        comment_bar.inputTextView.text = nil
        shows_comment_bar = false
        becomeFirstResponder()
    }
    
    override var inputAccessoryView: UIView? {
        return comment_bar
    }
    
    override var canBecomeFirstResponder: Bool {
        return shows_comment_bar
    }
    
    func messageInputBar(_ inputBar: MessageInputBar, didPressSendButtonWith text: String) {
        // create the comment
        
        
        // clear and dismiss input
        comment_bar.inputTextView.text = nil
        shows_comment_bar = false
        becomeFirstResponder()
        comment_bar.inputTextView.resignFirstResponder()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let query = PFQuery(className: "Posts")
        query.includeKeys(["author", "comments", "comments.author"])
        query.limit = 20
        query.findObjectsInBackground { (posts, error) in
            if posts != nil {
                self.posts = posts!
                self.tableView.reloadData()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let post = posts[section]
        let comments = (post["comments"] as? [PFObject]) ?? []
        
        return comments.count + 2
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let post = posts[indexPath.section]
        let comments = (post["comments"] as? [PFObject]) ?? []
        
        if indexPath.row == 0 {
            print("indexpath.row: \(indexPath.row)")
            let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell") as! PostCell
            let user = post["author"] as! PFUser
            cell.username_label.text = user.username
            cell.caption_label.text = post["caption"] as! String
            
            let image_file = post["image"] as! PFFileObject
            let url_string = image_file.url!
            let url = URL(string: url_string)!
            cell.photo_view.af_setImage(withURL: url)
            
            return cell
        } else if indexPath.row <= comments.count {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CommentTableViewCell") as! CommentTableViewCell
            
            let comment = comments[indexPath.row - 1]
            cell.comment_label.text = comment["text"] as? String
            
            let user = comment["author"] as! PFUser
            cell.username_label.text = user.username
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "AddCommentCell")!
            
            return cell
        }
    }
    
    
    
    @IBAction func onLogOut(_ sender: Any) {
        
        print("logging out..")
        PFUser.logOut()
    
        let main = UIStoryboard(name: "Main", bundle: nil)
        let login_view_controller = main.instantiateViewController(withIdentifier: "LoginViewController")
        let scene_delegate = self.view.window?.windowScene?.delegate as! SceneDelegate
        scene_delegate.window?.rootViewController = login_view_controller
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let post = posts[indexPath.row]
        let comments = (post["comments"] as? [PFObject]) ?? []
        
        if indexPath.row == comments.count + 1 {
            shows_comment_bar = true
            becomeFirstResponder()
            comment_bar.inputTextView.becomeFirstResponder()
            
        }
        
//        comment["text"] = "This is a random comment!"
//        comment["post"] = post
//        comment["author"] = PFUser.current()!
//
//        post.add(comment, forKey: "comments")
//
//        post.saveInBackground { (success, error) in
//            if success {
//                print("comment saved")
//            } else {
//                print("error saving comment")
//            }
//        }
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
