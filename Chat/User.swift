//
//  User.swift
//  Chat
//
//  Created by iOS on 7/5/17.
//  Copyright © 2017 Spencer Wallsworth. All rights reserved.
//

import UIKit

struct User{
    var id: String?
    var name: String?
    var imageURL: String?
    weak var image: UIImage?
    var posts:[String]?
    init(id:String, name:String, imageURL:String?, posts:[String]?){
        self.id = id
        self.name = name
        self.image = nil
        self.imageURL = imageURL
        self.posts = posts
    }
}
