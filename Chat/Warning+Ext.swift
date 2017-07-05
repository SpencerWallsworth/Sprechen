//
//  Warning+Ext.swift
//  Chat
//
//  Created by iOS on 7/4/17.
//  Copyright © 2017 Spencer Wallsworth. All rights reserved.
//

import UIKit
extension WarningDelegate where Self:UIViewController{
    func showWarning(message: String){
        let warningVC = UIAlertController(title: "Warning", message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        warningVC.addAction(action)
        present(warningVC, animated: true, completion: nil)
    }
}
