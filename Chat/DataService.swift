//
//  DataService.swift
//  Chat
//
//  Created by iOS on 7/5/17.
//  Copyright © 2017 Spencer Wallsworth. All rights reserved.
//

import Foundation
import Firebase


class DataService{
    static let shared = DataService()
    var base:DatabaseReference {
        return Database.database().reference()
    }
    var posts:DatabaseReference{
        return base.child("posts")
    }
    var users:DatabaseReference{
        return base.child("users")
    }
    
    private init(){}
    
    func createFirebaseDBUser(uid: String, userData: Dictionary<String, String>){
        users.child(uid.hashValue.description).updateChildValues(userData)
    }
    
    func getDataFromURL(url: URL, completion: @escaping (_ data: Data?, _  response:
        URLResponse?, _ error: Error?) -> ()){
        
        URLSession.shared.dataTask(with: url) {
            (data, response, error) in
            completion(data, response, error)
            }.resume()
    }
    
    func send(message: String, to user: User){
        let generatedChild = DataService.shared.base
        var value:[String : String] = [:]
        value["caption"] = message
        //The following line is inefficient, I will lookup the right way to get a random key
        let key: String = Int(drand48() * 1_000_000_000_000).description
        var userDic:[String : String] = [:]
        userDic[key] = true.description
        DataService.shared.posts.child(key).updateChildValues(value)
        DataService.shared.users.child(user.id!).child("posts").updateChildValues(userDic)
        //generatedChild.child("").updateChildValues(<#T##values: [AnyHashable : Any]##[AnyHashable : Any]#>)
    }
    
    func getAllPosts(from user: User, completion: @escaping (String)->()){
        var keys:[String] = []
        DataService.shared.users.child(user.id!).observeSingleEvent(of: .value, with: { (dataShot) in
            
            if let snapshot = dataShot.children.allObjects as? [DataSnapshot]{
                //Each user has keys that reference messages
                if snapshot.count >= 3{
                    if !((snapshot[2]).value is NSArray){
                        keys = Array(((snapshot[2]).value as! Dictionary<String, AnyObject>).keys)
                        //We have the keys for the user, now we need the message associated with the key
                        for key in keys{
                            DataService.shared.posts.child(key).observeSingleEvent(of: .value, with: { (datashot2) in
                                if let snapShot2 = datashot2.children.allObjects as? [DataSnapshot]{
                                    if snapShot2.count >= 0{
                                        if let result = (snapShot2[0].value) as? String{
                                            //update one message at a time
                                            completion(result)
                                        }
                                    }
                                }
                            })
                        }
                    }}
            }
        })
    }
}



