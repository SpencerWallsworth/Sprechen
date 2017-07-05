//
//  LoginViewModelDelegate.swift
//  Chat
//
//  Created by iOS on 7/4/17.
//  Copyright © 2017 Spencer Wallsworth. All rights reserved.
//

import Foundation
protocol LoginViewModelDelegate: class{
    func invalidLogin(message:String)
    func invalidAccountCreation(message:String)
    func validLogin()
    func errorSigningingOut(message:String)
    func updateView()
}
