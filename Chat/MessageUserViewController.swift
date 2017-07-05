//
//  MessageUserViewController.swift
//  Chat
//
//  Created by iOS on 7/5/17.
//  Copyright © 2017 Spencer Wallsworth. All rights reserved.
//

import UIKit

class MessageUserViewController: UIViewController, UITabBarDelegate, UINavigationControllerDelegate{

    @IBOutlet weak var textIput: UITextView!
    
    @IBOutlet weak var textOutput: UITextView!
    
    @IBOutlet weak var tabBar: UITabBar!
    @IBOutlet weak var sendMessageItem: UITabBarItem!
    
    var user:User?
    override func viewDidLoad() {
        super.viewDidLoad()
        tabBar.delegate = self
        textOutput.isEditable = false

        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
 
        
        //observe for changes then update text output
        DataService.shared.users.child((user?.id)!).observe(.value, with: { (datashot) in
            self.textOutput.text = ""
            
            //update text output
            DataService.shared.getAllPosts(from: self.user!) { (post) in
                DispatchQueue.main.async {
                    self.textOutput.text.append("\n\(post)")
                }
            }
            
            
        })
    }
    
    override func viewDidDisappear(_ animated: Bool) {
    
        DataService.shared.users.removeAllObservers()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //Mark: - TabBar Delegate function
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        if item == sendMessageItem{
            //Send information to Database
            DataService.shared.send(message: textIput.text, to: user!)
            
            //clear inputTextField
            
            textIput.text = ""
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
