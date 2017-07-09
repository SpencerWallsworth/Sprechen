//
//  UserSelectionViewModel.swift
//  Chat
//
//  Created by iOS on 7/5/17.
//  Copyright © 2017 Spencer Wallsworth. All rights reserved.
//

import Foundation
import UIKit
import Firebase
class UserSelectionViewModel{
    private var _users:[User] = []
    private var _imageCache =  NSCache<NSString, UIImage>()
    private var _observerID: UInt?
    var delegate: UserSelectionViewModelDelegate?
    init(){
        _imageCache.countLimit = 30
        _observerID = DataService.shared.users.observe(.value, with: { (snapshot) in
            //parse data
            if let snapshot = snapshot.children.allObjects as? [DataSnapshot]{
                for snap in snapshot{
                    if let userDic = (snap.value as? Dictionary<String, AnyObject>){
                        let imgURL = userDic["imageURL"] as? String ?? ""
                        let name = userDic["name"] as? String ?? ""
                        let id =  snap.key
                        self._users.append(User(id: id, name: name, imageURL: imgURL, posts: nil))
                    }
                }
            }
            
            //update view
            self.delegate?.updateView()
        })
    }
    func getUserAtRow(indexPath:IndexPath)->User{
        DataService.shared.users.removeObserver(withHandle: _observerID!)
        return _users[indexPath.row]
    }
    
    func getNumberOfUsers()->Int{
        return _users.count
    }
    func getUserImageURL(indexPath: IndexPath)->URL?{
        return URL(string: _users[indexPath.row].imageURL!)
    }
    
    func queryImage(for indexPath: IndexPath){
        if let url = URL(string: (_users[indexPath.row].imageURL)!){
            if let img = (_imageCache.object(forKey: url.absoluteString as NSString)){
                _users[indexPath.row].image = img
            }else{
                DataService.shared.getDataFromURL(url: url) { (data, response, error) in
                    if error == nil && data != nil{
                        DispatchQueue.main.async {
                            let image = UIImage(data: data!)
                            self._imageCache.setObject(image!, forKey: url.absoluteString as NSString)
                            self._users[indexPath.row].image = image
                            self.delegate?.updateView()
                        }
                    }
                }
            }
        }
    }
    
    func getUserName(email:String)->String?{
        let result = _users.filter{$0.id == email.hashValue.description}
        return result.count == 1 ? result.first?.name : nil
    }
}
