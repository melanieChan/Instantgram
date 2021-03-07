//
//  LoginViewController.swift
//  Instantgram
//
//  Created by Melanie Chan on 3/6/21.
//

import UIKit
import Parse

class LoginViewController: UIViewController {

    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    // make new account using user input
    @IBAction func onSignup(_ sender: Any) {
        let user = PFUser()
        
        // get user input
        user.username = usernameField.text
        user.password = passwordField.text
        
        // make account with user input
        user.signUpInBackground { (success, error) in
            // if successfully made account, segue to home feed
            if success {
                self.performSegue(withIdentifier: "LoginSegue", sender: nil)
            }
            
            else {
                print("Error making account \(error?.localizedDescription)")
            }
        }

    }
    
    // use user input to sign in to existing account
    @IBAction func onSignin(_ sender: Any) {
        let username = usernameField.text!
        let password = passwordField.text!
        
        PFUser.logInWithUsername(inBackground: username, password: password) { (user, error) in
            
            // correct login credentials
            if user != nil {
                self.performSegue(withIdentifier: "LoginSegue", sender: nil)
            }
            
            else {
                print("Error making account \(error?.localizedDescription)")

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
