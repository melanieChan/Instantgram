//
//  FeedViewController.swift
//  Instantgram
//
//  Created by Melanie Chan on 3/6/21.
//

import UIKit
import Parse
import AlamofireImage

class FeedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    let postsRefreshControl = UIRefreshControl()
    
    var posts = [PFObject]() // array of data retrieved from database
    
    var numberOfPosts = 20
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        
        postsRefreshControl.addTarget(self, action: #selector(onRefresh), for: .valueChanged)
        tableView.refreshControl = postsRefreshControl
        
        tableView.estimatedRowHeight = tableView.rowHeight
        tableView.rowHeight = UITableView.automaticDimension


    }
    
    @objc func onRefresh() {
        run(after: 2) {
           self.postsRefreshControl.endRefreshing()
        }
    }
    
    // delay
    func run(after wait: TimeInterval, closure: @escaping () -> Void) {
        let queue = DispatchQueue.main
        queue.asyncAfter(deadline: DispatchTime.now() + wait, execute: closure)
    }
    
    // to show recently created post after posting and returning to feed screen
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // get recently created post from database and display it
        let query = PFQuery(className: "Posts")
        query.includeKeys(["author", "Comments", "Comments.author"]) // get data of author
        query.limit = numberOfPosts
        
        query.findObjectsInBackground { (postsRetrieved, error) in
            if postsRetrieved != nil {
                self.posts = postsRetrieved!
                
                self.tableView.reloadData()
            }
        }
    }
    
    // how many rows per section
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // 1 post + number of comments that post has
        let post = posts[section]
        let comments = (post["Comments"] as? [PFObject]) ?? []
        
        return 1 + comments.count
    }
    
    // each post gets its own section, section will contain post and comments for that post
    func numberOfSections(in tableView: UITableView) -> Int {
        return posts.count
    }
    
    // determine row height
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        // if post
        if indexPath.row == 0 {
            return 500
        }
        
        // if comment
        return UITableView.automaticDimension
    }
    
    // make a row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // reverse chronological order display of posts
//        let indexOfLastItem = posts.count - 1
//        let post = posts[indexOfLastItem - indexPath.row]

        // chronological order
        let post = posts[indexPath.section] // get post
        let comments = (post["Comments"] as? [PFObject]) ?? [] // get comments for post
        print(comments)
        
        // creating post cell
        if indexPath.row == 0 { // post cell is first cell in section
//            tableView.rowHeight = 500
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell") as! PostCell

            let user = post["author"] as! PFUser
            
            // set data
            cell.usernameLabel.text = user.username
            cell.commentLabel.text = post["caption"] as! String
            
            // set image
            let imageFile = post["image"] as! PFFileObject
            let urlString = imageFile.url!
            let url = URL(string: urlString)!
            
            cell.photoView.af_setImage(withURL: url)
            
            return cell
        }
        
        // create comment cells
        else {
            let commentCell = tableView.dequeueReusableCell(withIdentifier: "CommentCell") as! CommentCell
            
            let comment = comments[indexPath.row - 1]
            
            commentCell.commentLabel.text = comment["text"] as? String
            
            let author = comment["author"] as! PFUser
            commentCell.nameLabel.text = author.username

            return commentCell
        }
    }
    
    // for infinite scroll
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row + 1 == posts.count {
            numberOfPosts = numberOfPosts + 20
            self.viewDidAppear(true)
        }
    }
    
    // when user logs out
    @IBAction func onLogout(_ sender: Any) {
        PFUser.logOut()
        
        // switch screens
        
        let main = UIStoryboard(name: "Main", bundle: nil)
        
        let loginViewController = main.instantiateViewController(identifier: "LoginViewController")
        
        // set window
//        let delegate = UIApplication.shared.delegate as! AppDelegate
        let delegate = self.view.window?.windowScene?.delegate as! SceneDelegate
        
        delegate.window?.rootViewController = loginViewController
    }
    
    // add comment when cell is clicked
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let post = posts[indexPath.row]
        
        let comment = PFObject(className: "Comments")
        
        comment["text"] = "comment text"
        comment["post"] = post
        comment["author"] = PFUser.current()
        
        // make array of comments for each post & add current comment to array
        post.add(comment, forKey: "Comments")
        
        post.saveInBackground { (success, error) in
            if success {
                print("comment saved")
            } else {
                print("error saving comment")
            }
        }
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
