//
//  ChatViewController.swift
//  lab_ParseChat
//
//  Created by PJ Martinez on 2/21/18.
//  Copyright © 2018 Paolo Martinez. All rights reserved.
//

import UIKit
import Parse
import KRProgressHUD

class ChatViewController: ViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet var messageTableView: UITableView!
    @IBOutlet var chatMessageField: UITextField!
    var messages: [PFObject] = []
    var refreshControl: UIRefreshControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        messageTableView.dataSource = self
        messageTableView.delegate = self
        messageTableView.rowHeight = UITableViewAutomaticDimension
        messageTableView.estimatedRowHeight = 50
        
        handlePullToRefresh()
        
        KRProgressHUD.show()
        getMessages()
        DispatchQueue.main.asyncAfter(deadline: .now()+1) {
            KRProgressHUD.dismiss()
        }
        
        // Table fetches messages every 1 second
        Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.getMessages), userInfo: nil, repeats: true)
        
    }
    
    func handlePullToRefresh() {
        // Pull to refresh
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(ChatViewController.didPullToRefresh(_:)), for: .valueChanged)
        messageTableView.insertSubview(refreshControl, at: 0)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func didPullToRefresh(_ refreshControl: UIRefreshControl) {
        getMessages()
    }
    
    @IBAction func onSend(_ sender: Any) {
        let chatMessage = PFObject(className: "Message")
        chatMessage["user"] = PFUser.current()
        chatMessage["text"] = chatMessageField.text ?? ""
        chatMessage.saveInBackground { (success, error) in
            if success {
                print("The message was saved!")
                self.chatMessageField.text = ""
            } else if let error = error {
                print("Problem saving message: \(error.localizedDescription)")
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count;
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = messageTableView.dequeueReusableCell(withIdentifier: "ChatCell", for: indexPath) as! ChatCell
        let message = messages[indexPath.row]["text"] as! String
        cell.messageLabel.text = message
        
        if let user = messages[indexPath.row]["user"] as? PFUser {
            // User found! update username label with username
            cell.usernameLabel.text = user.username
        } else {
            // No user found, set default username
            cell.usernameLabel.text = "🤖"
        }
        return cell
    }
    
    
    @objc func getMessages() {
        let query = PFQuery(className: "Message")
        query.addDescendingOrder("createdAt")
        query.includeKey("user")
        
        query.findObjectsInBackground { (messages: [PFObject]?, error: Error?) in
            if let messages = messages {
                self.messages = messages
                print(self.messages)
                
            } else {
                print("Error from chat view controller trying to get messages in getMessages() function with localized description \"\(error!.localizedDescription)\"")
            }
        }
        self.messageTableView.reloadData()
        self.refreshControl.endRefreshing()
    }
}
