//
//  LoginViewController.swift
//  lab_ParseChat
//
//  Created by PJ Martinez on 2/21/18.
//  Copyright © 2018 Paolo Martinez. All rights reserved.
//

import UIKit
import Parse

class LoginViewController: ViewController {

    @IBOutlet var usernameField: UITextField!
    @IBOutlet var passwordField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //TODO: implement this to keep code DRY
    func checkFields() {
        let alertController = UIAlertController(title: "Username/Password Required", message: "Please enter both a valid username and password", preferredStyle: .alert)
        
        // create an OK action
        let OKAction = UIAlertAction(title: "OK", style: .default) { (action) in
            // handle response here. doing nothing will dismiss view
        }
        // add the OK action to the alert controller
        alertController.addAction(OKAction)
        
        if(usernameField.text?.isEmpty == true || passwordField.text?.isEmpty == true) {
            present(alertController, animated: true) {
                // optional code for what happens after the alert controller has finished presenting
            }
        }
    }
    
    
    @IBAction func onSignUp(_ sender: Any) {
        // initialize a user object
        let newUser = PFUser()
        
        // set user properties
        newUser.username = usernameField.text
        newUser.password = passwordField.text
        
        let alertController = UIAlertController(title: "Username/Password Required", message: "Please enter both a valid username and password", preferredStyle: .alert)
        
        // create an OK action
        let OKAction = UIAlertAction(title: "OK", style: .default) { (action) in
            // handle response here. doing nothing will dismiss view
        }
        alertController.addAction(OKAction)
        
        let errorAlertController = UIAlertController(title: "Signup/Login Error", message: "There was an error signing up/logging in as this user. Please try again", preferredStyle: .alert)
        
        errorAlertController.addAction(OKAction)
        
        if(usernameField.text?.isEmpty == true || passwordField.text?.isEmpty == true) {
            present(alertController, animated: true) {
                // optional code for what happens after the alert controller has finished presenting
            }
        } else {
            // call sign up function on the object
            newUser.signUpInBackground { (success: Bool, error: Error?) in
                if let error = error {
                    print(error.localizedDescription)
                } else  {
                    print("User Registered successfully")
                    // manually segue to logged in view
                    self.performSegue(withIdentifier: "loginSegue", sender: nil)
                }
            }
        }
    }
    
    @IBAction func onSignIn(_ sender: Any) {
        let username = usernameField.text ?? ""
        let password = passwordField.text ?? ""
        
        let alertController = UIAlertController(title: "Username/Password Required", message: "Please enter both a valid username and password", preferredStyle: .alert)
        
        // create an OK action
        let OKAction = UIAlertAction(title: "OK", style: .default) { (action) in
            // handle response here. doing nothing will dismiss view
        }
        alertController.addAction(OKAction)
        
        let errorAlertController = UIAlertController(title: "Signup/Login Error", message: "There was an error signing up/logging in as this user. Please try again", preferredStyle: .alert)
        
        errorAlertController.addAction(OKAction)
        
        if(usernameField.text?.isEmpty == true || passwordField.text?.isEmpty == true) {
            present(alertController, animated: true) {
                // optional code for what happens after the alert controller has finished presenting
            }
        } else {
        
            PFUser.logInWithUsername(inBackground: username, password: password) { (user: PFUser?, error: Error?) in
                if let error = error {
                    print("User log in failed: \(error.localizedDescription)")
                } else {
                    print("User logged in successfully")
                    // display view controller that needs to shown after successful login
                    self.performSegue(withIdentifier: "loginSegue", sender: nil)
                }
            }
        }
    }

}
