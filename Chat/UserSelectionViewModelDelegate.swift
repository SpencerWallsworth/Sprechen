//
//  UserSelectionViewModelDelegate.swift
//  Chat
//
//  Created by iOS on 7/5/17.
//  Copyright © 2017 Spencer Wallsworth. All rights reserved.
//

import Foundation
protocol UserSelectionViewModelDelegate{
    func updateView()
    func updateView(for indexPath:IndexPath)
}
