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
        query.includeKey("author") // get data of author
        query.limit = numberOfPosts
        
        query.findObjectsInBackground { (postsRetrieved, error) in
            if postsRetrieved != nil {
                self.posts = postsRetrieved!
                
                self.tableView.reloadData()
            }
        }
    }
    
    // how many rows in table view
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    // make a row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell") as! PostCell
        
        // reverse chronological order display of posts
//        let indexOfLastItem = posts.count - 1
//        let post = posts[indexOfLastItem - indexPath.row]

        // chronological order
        let post = posts[indexPath.row]
        
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
    
    // for infinite scroll
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row + 1 == posts.count {
            numberOfPosts = numberOfPosts + 20
            self.viewDidAppear(true)
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
