//
//  UserSelectionViewModel.swift
//  Chat
//
//  Created by iOS on 7/5/17.
//  Copyright © 2017 Spencer Wallsworth. All rights reserved.
//

import Foundation
import Firebase
class UserSelectionViewModel{
    private var _users:[User] = []
    private var _observerID: UInt?
    var delegate: UserSelectionViewModelDelegate?
    init(){
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
    func getUserName(email:String)->String?{
        let result = _users.filter{$0.id == email.hashValue.description}
        return result.count == 1 ? result.first?.name : nil
    }
    
    

}
