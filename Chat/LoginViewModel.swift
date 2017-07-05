//
//  LoginViewModel.swift
//  Chat
//
//  Created by iOS on 7/4/17.
//  Copyright © 2017 Spencer Wallsworth. All rights reserved.
//

import Foundation
import Firebase
 
class LoginViewModel{
    weak var delegate: LoginViewModelDelegate?
    
    func login(email: String, password: String){
        if delegate != nil{
            Auth.auth().signIn(withEmail: email, password: password, completion: { (user, error) in
                if error != nil{
                    self.delegate?.invalidLogin(message: "Unable to sign in")
                }else{
                    self.delegate?.validLogin()
                }
            })
            
        }
    }
    
    func createAccount(username: String, email: String, password1: String, password2: String){
        //If password1 does not equal password2 Show warning message
        if delegate != nil{
            if password1 != password2{
                signout()
                delegate?.invalidAccountCreation(message: "Passwords do not match")
            }else if !validatePassword(password: password1){
                signout()
                delegate?.invalidAccountCreation(message: "Invalid Password")
            }else{
                Auth.auth().createUser(withEmail: email, password: password1, completion: { (user, error) in
                    if error != nil{
                        self.signout()
                        self.delegate?.invalidAccountCreation(message: "Error, unable to create account")
                    }else{
                        var userInfo = [String:String]()
                        userInfo["name"] = username
                        let imagePlaceholder = "http://orig13.deviantart.net/4a32/f/2013/089/e/3/profile_picture_by_frogstar_23-d5zu8yq.png"
                        userInfo["imageURL"] = imagePlaceholder
                        DataService.shared.createFirebaseDBUser(uid: email, userData: userInfo)
                        self.delegate?.validLogin()
                    }
                })
            }
        }
    }
    
    func signout(){
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
    }
    //Make up rules using RegEx
    func validatePassword(password:String)->Bool{
        return true
    }

}
