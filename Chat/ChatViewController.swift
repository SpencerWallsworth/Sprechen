//
//  ChatViewController.swift
//  Chat
//
//  Created by iOS on 7/4/17.
//  Copyright © 2017 Spencer Wallsworth. All rights reserved.
//

import UIKit
import AVFoundation

class ChatViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITableViewDelegate, UITableViewDataSource, UITabBarDelegate, UIPopoverPresentationControllerDelegate, ImageURLDelegate, WarningDelegate, UserSelectionViewModelDelegate{

    
    @IBOutlet weak var tableView: UITableView!
    
    
    @IBOutlet weak var photoItem: UITabBarItem!
    
    @IBOutlet weak var cameraItem: UITabBarItem!
    
    
    @IBOutlet weak var imageURLItem: UITabBarItem!
    
    @IBOutlet weak var profileImage: UIImageView!
    let imagePicker = UIImagePickerController()
    
    @IBOutlet weak var name: UILabel!
    
    var userSelectionViewModel:UserSelectionViewModel?
    var email:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.

        let nib = UINib(nibName: "UserChatTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "userChatCell")
        imagePicker.delegate = self
        
        userSelectionViewModel = UserSelectionViewModel()
        userSelectionViewModel?.delegate = self
        
        
    }

  

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    // MARK: - TabBar delegate function
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        if item == cameraItem{
            imagePicker.sourceType = .camera
        }else if item == photoItem{
            imagePicker.sourceType = .photoLibrary
        }else if item == imageURLItem{
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "ImageURLViewController") as! ImageURLViewController
            vc.delegate = self
            vc.modalPresentationStyle = UIModalPresentationStyle.popover
            let popover: UIPopoverPresentationController = vc.popoverPresentationController!
            vc.preferredContentSize = CGSize(width: 400, height: 70)
            popover.sourceView = UIView(frame: CGRect(x: 0, y: self.view.frame.height - tabBar.frame.height, width: tabBar.frame.width * 0.333, height: tabBar.frame.height))
            
            self.present(vc, animated: true, completion: nil)
        }
        imagePicker.allowsEditing = false
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    // MARK: - ImagePicker delegate functions
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let pickedImage = info["UIImagePickerControllerOriginalImage"] as? UIImage{
            profileImage.image = pickedImage
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    
    func retrieveImage(string: String) {
        if let url = URL(string: string){
            DataService.shared.getDataFromURL(url: url, completion: { (data, response, error) in
                
                if error != nil{
                    self.showWarning(message: "Can not download image")
                }
                if let image = UIImage(data: data!){
                    self.profileImage.image = image
                }else{
                    self.showWarning(message: "Image was corrupted")
                }
                
            })
        }
    }
    
    // MARK: - Tableview Delegate functions
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userSelectionViewModel!.getNumberOfUsers()
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "userChatCell") as!UserChatTableViewCell
        
        //Set cell text label
        cell.userName.text = userSelectionViewModel?.getUserAtRow(indexPath: indexPath).name
        
        
        //Set cell image
        let url = userSelectionViewModel?.getUserImageURL(indexPath: indexPath)
        DataService.shared.getDataFromURL(url: url!) { (data, response, error) in
            if error == nil && data != nil{
                DispatchQueue.main.async {
                    cell.profileImageView.image = UIImage(data: data!)
                }
            }
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let user = userSelectionViewModel?.getUserAtRow(indexPath: indexPath)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "messageUserViewController") as! MessageUserViewController
        vc.user = user
        self.navigationController?.pushViewController(vc, animated: true)
    }
  
    func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.none
    }
    
    // Mark: - UserSelectionViewDelegate methods
    func selectUser(indexPath: IndexPath) {
        
    }
    func updateView() {
        self.name.text =  userSelectionViewModel?.getUserName(email: email!)
        tableView.reloadData()
    }
    

    
    
    //TODO: Network request here, refactor it out
   
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
